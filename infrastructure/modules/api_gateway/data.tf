data "aws_lb" "nlb" {
   name = "${var.application_name}-nlb"
}