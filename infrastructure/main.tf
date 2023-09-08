provider "aws" {
  region = var.region
}

module "vpc" {
  source           = "./modules/vpc"
  application_name = var.application_name
  region           = var.region
  vpc_name         = var.vpc_name
}

module "lb" {
  source           = "./modules/lb"
  application_name = var.application_name
  region           = var.region
  vpc_name         = var.vpc_name
  depends_on       = [module.vpc]
}

module "api_gateway" {
  source           = "./modules/api_gateway"
  application_name = var.application_name
  depends_on       = [module.lb]
}