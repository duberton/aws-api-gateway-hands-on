resource "aws_ssm_parameter" "db_url" {
  name  = "db_url"
  type  = "String"
  value = "url"
}

resource "aws_ssm_parameter" "db_user" {
  name  = "db_user"
  type  = "String"
  value = "user"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "db_password"
  type  = "String"
  value = "pwd"
}