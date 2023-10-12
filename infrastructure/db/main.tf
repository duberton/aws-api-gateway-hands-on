provider "aws" {
  region = var.region
}

module "db" {
  source   = "./modules/db"
  vpc_name = var.vpc_name
}