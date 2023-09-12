module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.application_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_rules = ["all-all"]

  tags = {
    name = "sg"
  }
}
