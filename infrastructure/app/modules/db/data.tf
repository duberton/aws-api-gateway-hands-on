data "aws_ssm_parameter" "db_url" {
  name = "db_url"
}

data "aws_secretsmanager_secret" "db_secrets" {
  name = "db_secrets"
}

data "aws_secretsmanager_secret_version" "db_secrets_version" {
  secret_id = data.aws_secretsmanager_secret.db_secrets.id
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

data "aws_security_group" "sg" {
  tags = {
    name = "sg"
  }
}