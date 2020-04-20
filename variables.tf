variable "aws_region" {}

# Networking Variables...
variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}
variable "tenancy" {}

variable "accessip" {}

# EC2 Variables...
variable "key_name" {}
variable "instance_count" {}
variable "instance_type" {}
