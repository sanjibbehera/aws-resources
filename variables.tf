# global
variable "aws_region" {}

# networking
variable "vpc_cidr" {}
variable "tenancy" {}
variable "public_subnet_count" {}
variable "private_subnet_count" {}

variable "vpc_id" {}

variable "public_subnet_cidr" {
    type = list(string)
}

variable "private_subnet_cidr" {
    type = list(string)
}

# ec2
variable "instance_count" {}
variable "instance_type" {}
variable "key_name" {}
variable "accessip" {}