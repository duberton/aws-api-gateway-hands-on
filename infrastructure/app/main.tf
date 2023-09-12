provider "aws" {
  region = var.region
}

module "lb" {
  source           = "./modules/lb"
  application_name = var.application_name
  region           = var.region
  vpc_name         = var.vpc_name
}

module "ecs" {
  source           = "./modules/ecs"
  application_name = var.application_name
  vpc_name         = var.vpc_name
  depends_on       = [module.lb]
}

module "api_gateway" {
  source           = "./modules/api_gateway"
  application_name = var.application_name
  depends_on       = [module.ecs]
}