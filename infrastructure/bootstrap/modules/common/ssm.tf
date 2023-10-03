resource "aws_ssm_parameter" "db_url" {
  name  = "db_url"
  type  = "String"
  value = "url"
}