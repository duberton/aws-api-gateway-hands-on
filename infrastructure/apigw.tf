provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
}

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
  template = file("../openapi/bands.yaml")
}