resource "aws_api_gateway_rest_api" "bands_rest_api_gateway" {
  name = "Bands AWS API Gateway"
  body = data.template_file.bands_openapi_file.rendered
}

resource "aws_api_gateway_deployment" "bands_rest_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.bands_rest_api_gateway.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "bands_rest_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.bands_rest_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.bands_rest_api_gateway.id
  stage_name    = "default"
}

data "template_file" "bands_openapi_file" {
  template = templatefile("../../openapi/bands.yaml", {
    nlb_dns_name = data.aws_lb.nlb.dns_name,
    vpc_link_id = aws_api_gateway_vpc_link.bands_rest_api_gateway_vpc_link.id
  })
}

resource "aws_api_gateway_vpc_link" "bands_rest_api_gateway_vpc_link" {
  name = "${var.application_name}-vpc_link"
  target_arns = [ data.aws_lb.nlb.arn ]
}