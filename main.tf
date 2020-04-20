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
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_cidrs    = var.public_cidrs
  private_cidrs   = var.private_cidrs
  tenancy         = var.tenancy
  accessip        = var.accessip
}

# Create EC2 Instance...
module "ec2_resources" {
  source                 = "./modules/ec2"
  key_name               = var.key_name
  instance_count         = var.instance_count
  instance_type          = var.instance_type
  subnet_id              = "${module.networking.subnet_id}"
  #vpc_security_group_ids = ["${module.networking.security_group_id}"]
}