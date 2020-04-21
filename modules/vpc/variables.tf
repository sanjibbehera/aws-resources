variable "vpc_cidr" {}
variable "tenancy" {}

variable "vpc_id" {}
variable "public_subnet_count" {}
variable "private_subnet_count" {}

variable "public_subnet_cidr" {
    type = list(string)
}

variable "private_subnet_cidr" {
    type = list(string)
}