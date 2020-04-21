# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEV_ROOT/MAIN.TF FILE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

# Create VPC for Aapche webapp.
module "networking" {
  source                 = "./modules/vpc"
  vpc_cidr               = var.vpc_cidr
  tenancy                = var.tenancy
  public_subnet_count    = var.public_subnet_count
  private_subnet_count   = var.private_subnet_count
  vpc_id                 = module.networking.vpc_id
  public_subnet_cidr     = var.public_subnet_cidr
  private_subnet_cidr    = var.private_subnet_cidr
}

# Create EC2 Instance...
module "ec2_resources" {
  source                 = "./modules/ec2"
  key_name               = var.key_name
  instance_count         = var.instance_count
  instance_type          = var.instance_type
  subnet_id              = module.networking.public_subnet_id
  vpc_id                 = module.networking.vpc_id
  accessip               = var.accessip
}