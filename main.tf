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

# Create ELB...
module "elb_resources" {
  source                 = "./modules/elb"
  vpc_id                 = module.networking.vpc_id
  subnets                = module.networking.public_subnets
  attachment_count       = var.attachment_count
  target_id              = module.ec2_resources.instance_ids
  elb_instance_http_port = var.elb_instance_http_port
  elb_lb_port            = var.elb_lb_port
  healthy_threshold      = var.healthy_threshold
  unhealthy_threshold    = var.unhealthy_threshold
  health_check_interval  = var.health_check_interval
  health_port            = var.health_port
  protocol               = var.protocol
}