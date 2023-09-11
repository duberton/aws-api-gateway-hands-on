module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${var.application_name}-ecs"

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
      "name": "${var.application_name}",
      "image": "${data.aws_ecr_repository.ecr.repository_url}/${var.application_name}",
      "environment": [
        {
          "name": "DB_URL",
          "value": "url"
        },
        {
          "name": "DB_USER",
          "value": "user"
        },
        {
          "name": "DB_PASSWORD",
          "value": "pwd"
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
          "awslogs-stream-prefix": "ecs"
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
  memory                   = "1024"
  cpu                      = "512"
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
    security_groups = [data.aws_security_group.sg.id]
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = data.aws_lb_target_group.tg.arn
    container_name   = var.application_name
    container_port   = "8080"
  }
}