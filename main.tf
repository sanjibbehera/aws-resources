# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEV_ROOT/MAIN.TF FILE
# Author : SANJIB BEHERA
# Version: SB_0.1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

# Module to create a new Dynamodb Table..
module "createDynamoDBTable" {
  source                    = "./modules/dynamodb"
  table_name                = var.table_name
  billing_mode              = var.billing_mode
  rcu                       = var.rcu
  wcu                       = var.wcu
  hash_key                  = var.hash_key
}

# Module to create VPC resources.
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

# Module to create EC2 Instance(s), 1 Bastion Instance in Public Subnet, 
# 2 Apache Web Applications in Private Subnets...
module "ec2_resources" {
  source                 = "./modules/ec2"
  key_name               = var.key_name
  instance_count         = var.instance_count
  bastion_instance_count = var.bastion_instance_count
  baseami_instance_count = var.baseami_instance_count
  instance_type          = var.instance_type
  public_subnet_id       = module.networking.public_subnet_id
  private_subnet_id      = module.networking.private_subnet_id
  vpc_id                 = module.networking.vpc_id
  accessip               = var.accessip
  iam_instance_profile   = module.iam_roles.ec2_instance_profile
}

# Module to create IAM Roles, i.e., SSM Role that can be attached to EC2 as Instance Role...
module "iam_roles" {
  source                 = "./modules/iam"
}

# Create ELB which points to the 2 Apache Web Servers as Target groups...
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
  security_group_id      = module.ec2_resources.private_security_group_id
}

# Module to create MySQL V5.7 in Private Subnet.
module "mysql_instance" {
  source                    = "./modules/rds"
  RDS_PASSWORD              = var.RDS_PASSWORD
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.private_subnets
  privateEC2InstanceSG      = module.ec2_resources.private_security_group_id
}

# Module to create a new EC2 Instance on public Subnet & public SG and then create AMI from this EC2 Instance.
module "createAMI" {
  source                    = "./modules/compute"
  source_instance_id        = module.ec2_resources.base_ec2_instance
}