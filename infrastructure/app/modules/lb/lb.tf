module "nlb" {
  source = "terraform-aws-modules/alb/aws"

  name = "ecs-nlb"

  load_balancer_type = "network"

  vpc_id          = data.aws_vpc.vpc.id
  subnets         = data.aws_subnets.public.ids
  security_groups = [data.aws_security_group.sg.id]

  target_groups = [
    {
      name_prefix          = "tg-"
      backend_protocol     = "TCP"
      backend_port         = 8080
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 40
        path                = "/actuator/health"
        healthy_threshold   = 2
        unhealthy_threshold = 4
        timeout             = 3
        matcher             = "200-299"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      action_type        = "forward"
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  tags = {
    Name = "${var.application_name}-nlb"
  }

  target_group_tags = {
    Resource = "${var.application_name}-nlb-tg"
  }
}

resource "random_string" "tg-suffix" {
  length  = 4
  upper   = false
  special = false
}
