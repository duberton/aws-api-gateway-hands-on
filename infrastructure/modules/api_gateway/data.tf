data "aws_lb" "nlb" {
  tags = {
    Name = "aws-api-gateway-hands-on-app-nlb"
  }
}
