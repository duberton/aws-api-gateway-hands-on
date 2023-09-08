module "nlb" {
  source  = "terraform-aws-modules/alb/aws"

  name = "${var.application_name}-nlb"

  load_balancer_type = "network"

  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.public.ids
  security_groups    = [data.aws_security_group.sg.id]

  target_groups = [
    {
      name_prefix      = "tg"
      backend_protocol = "TCP"
      backend_port     = 8080
      target_type      = "instance"
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
}