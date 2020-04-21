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

# elb
variable "elb_instance_http_port" {}
variable "elb_lb_port" {}
variable "healthy_threshold" {}
variable "unhealthy_threshold" {}
variable "health_check_interval" {}

variable "health_port" {}
variable "protocol" {}
variable "attachment_count" {}