module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.application_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_rules = ["all-all"]

  tags = {
    name = "sg"
  }
}
