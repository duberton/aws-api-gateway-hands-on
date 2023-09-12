data "aws_ecr_repository" "ecr" {
  name = "${var.application_name}-ecr"
}

data "aws_lb_target_group" "tg" {
  tags = {
    Resource = "aws-api-gateway-hands-on-app-nlb-tg"
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    type = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    type = "public"
  }
}

data "aws_security_group" "sg" {
  tags = {
    name = "sg"
  }
}

data "aws_iam_role" "execution_role" {
  name = "execution_role"
}

data "aws_iam_role" "task_role" {
  name = "task_role"
}

data "aws_ssm_parameter" "db_url" {
  name = "db_url"
}

data "aws_ssm_parameter" "db_user" {
  name = "db_user"
}

data "aws_ssm_parameter" "db_password" {
  name = "db_password"
}