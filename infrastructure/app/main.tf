provider "aws" {
  region = var.region
}

module "db" {
  source   = "./modules/db"
  vpc_name = var.vpc_name
}

module "lb" {
  source           = "./modules/lb"
  application_name = var.application_name
  region           = var.region
  vpc_name         = var.vpc_name
  depends_on       = [module.db]
}

module "ecs" {
  source           = "./modules/ecs"
  application_name = var.application_name
  vpc_name         = var.vpc_name
  depends_on       = [module.lb]
}