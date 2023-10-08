data "aws_lb" "nlb" {
  tags = {
    Name = "aws-api-gateway-hands-on-app-nlb"
  }
}

data "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name = "${var.application_name}-api-gw"
}