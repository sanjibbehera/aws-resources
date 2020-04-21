# ---------------------------------------------------------------------------------------------------------------------
# First Create a VPC...
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

resource "aws_vpc" "sanjib_vpc" {
    cidr_block           = var.vpc_cidr
    instance_tenancy     = var.tenancy
    enable_dns_hostnames = true
    enable_dns_support   = true

  tags = {
    Name = "sanjib_vpc"
  }
}

resource "aws_internet_gateway" "sanjib_vpc_internet_gateway" {
  vpc_id = var.vpc_id


  tags = {
    Name = "sanjib_igw"
  }

  depends_on = [
      aws_vpc.sanjib_vpc
  ]
}

resource "aws_route_table" "sanjib_vpc_public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sanjib_vpc_internet_gateway.id
  }

  tags = {
    Name = "sanjib_public_rt"
  }
}

resource "aws_default_route_table" "sanjib_vpc_private_rt" {
  default_route_table_id  = aws_vpc.sanjib_vpc.default_route_table_id

  tags = {
    Name = "sanjib_private_rt"
  }
}

resource "aws_subnet" "sanjib_public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "sanjib_public_${count.index + 1}"
  }
}

resource "aws_subnet" "sanjib_private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "sanjib_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "sanjib_public_assoc" {
  count          = length(aws_subnet.sanjib_public_subnet)
  subnet_id      = aws_subnet.sanjib_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.sanjib_vpc_public_rt.id
}

resource "aws_route_table_association" "sanjib_private_assoc" {
  count          = length(aws_subnet.sanjib_private_subnet)
  subnet_id      = aws_subnet.sanjib_private_subnet.*.id[count.index]
  route_table_id = aws_vpc.sanjib_vpc.default_route_table_id
}