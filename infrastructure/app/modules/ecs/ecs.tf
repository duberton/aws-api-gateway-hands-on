locals {
  # db_url      = data.aws_ssm_parameter.db_url.value
  db_url      = data.aws_db_instance.db.endpoint
  db_user     = "${data.aws_secretsmanager_secret_version.db_secrets_version.arn}:user::"
  db_password = "${data.aws_secretsmanager_secret_version.db_secrets_version.arn}:password::"
  dd_api_key  = "${data.aws_secretsmanager_secret_version.dd_api_key_version.arn}:key::"
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${var.application_name}-cluster"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = var.application_name

  container_definitions = <<EOF
  [
    {
      "name": "datadog-agent",
      "essential": false,
      "image": "public.ecr.aws/datadog/agent:latest",
      "secrets": [
        {
          "name": "DD_API_KEY",
          "valueFrom": "${local.dd_api_key}"
        }
      ],
      "environment": [
        {
          "name": "DD_APM_IGNORE_RESOURCES",
          "value": "GET /actuator/health"
        },
        {
          "name": "DD_SITE",
          "value": "datadoghq.com"
        },
        {
          "name": "DD_SERVICE",
          "value": "${var.application_name}"
        },
        {
          "name": "DD_APM_ENABLED",
          "value": "true"
        },
        {
          "name": "DD_APM_NON_LOCAL_TRAFFIC",
          "value": "true"
        },
        {
          "name": "DD_ENV",
          "value": "dev"
        },
        {
          "name": "ECS_FARGATE",
          "value": "true"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/fargate-task-definition",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs",
          "awslogs-create-group": "true"
        }
      },
      "healthCheck": {
        "retries": 3,
        "command": [
          "CMD-SHELL",
          "agent health"
          ],
        "timeout": 2,
        "interval": 5,
        "startPeriod": 15
      },
      "cpu": 256,
      "memory": 512
    },
    {
      "name": "${var.application_name}",
      "image": "${data.aws_ecr_repository.ecr.repository_url}:latest",
      "secrets": [
        {
          "name": "DB_USER",
          "valueFrom": "${local.db_user}"
        },
        {
          "name": "DB_PASSWORD",
          "valueFrom": "${local.db_password}"
        }
      ],
      "environment": [
        {
          "name": "DD_SERVICE",
          "value": "${var.application_name}"
        },
        {
          "name": "DB_URL",
          "value": "jdbc:postgresql://${local.db_url}/postgres"
        }
      ],
      "essential": true,
      "portMappings": [
        {
          "name": "${var.application_name}",
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "us-east-1",
          "awslogs-group": "/aws/ecs/${var.application_name}",
          "awslogs-stream-prefix": "ecs",
          "awslogs-create-group": "true"
        }
      },
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "curl http://localhost:8080/actuator/health"
        ],
        "interval": 5,
        "timeout": 2,
        "retries": 3,
        "startPeriod": 40
      },
      "cpu": 512,
      "memory": 1024
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "1024"
  execution_role_arn       = data.aws_iam_role.execution_role.arn
  task_role_arn            = data.aws_iam_role.task_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name                   = var.application_name
  cluster                = module.ecs.cluster_id
  task_definition        = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count          = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.sg_ecs.id]
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = data.aws_lb_target_group.tg.arn
    container_name   = var.application_name
    container_port   = "8080"
  }
}
