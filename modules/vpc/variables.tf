#----modules/vpc/variables.tf----
variable "vpc_cidr" {}
variable "tenancy" {}

variable "accessip" {}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}