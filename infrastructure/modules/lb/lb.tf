module "nlb" {
  source  = "terraform-aws-modules/alb/aws"

  name = "nlb-${random_string.tg-suffix.result}"

  load_balancer_type = "network"

  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.public.ids
  security_groups    = [data.aws_security_group.sg.id]

  target_groups = [
    {
      name      = "tg-${random_string.tg-suffix.result}"
      backend_protocol = "TCP"
      backend_port     = 8080
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
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
