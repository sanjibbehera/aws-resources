# ---------------------------------------------------------------------------------------------------------------------
# First Create a VPC...
# Author : SANJIB BEHERA
# Version: SB_0.1
# ---------------------------------------------------------------------------------------------------------------------

# AWS AZ(s) to be used as datasource here..
data "aws_availability_zones" "available" {}

# Create a new VPC resource...
resource "aws_vpc" "sanjib_vpc" {
    cidr_block           = var.vpc_cidr
    instance_tenancy     = var.tenancy
    enable_dns_hostnames = true
    enable_dns_support   = true

  tags = {
    Name = "sanjib_vpc"
  }
}

# Create a new public subnet resource(s)...
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

# Create a new private subnet resource(s)...
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

# Create a Internet Gateway to access Internet...
resource "aws_internet_gateway" "sanjib_vpc_internet_gateway" {
  vpc_id = var.vpc_id


  tags = {
    Name = "sanjib_igw"
  }

  depends_on = [
      aws_vpc.sanjib_vpc
  ]
}

# Create a new Elastic IP[Static IP] to be attached to NAT Gateway.
resource "aws_eip" "sanjib-eip-natgw" {
  vpc      = true
}

# Create a new NAT Gateway in the Public Subnet.
# Private EC2 Instance(s) do not have access to Internet.
# Hence to access the same, Private EC2 Instance(s) should connect to NAT Gateway via the Default (Private) Route Table.
resource "aws_nat_gateway" "sanjib-natgw" {
  subnet_id     = aws_subnet.sanjib_public_subnet.*.id[0]
  allocation_id = aws_eip.sanjib-eip-natgw.id

  tags = {
    Name = "sanjib_NAT_gateway"
  }

  depends_on = [
      aws_internet_gateway.sanjib_vpc_internet_gateway,
      aws_subnet.sanjib_public_subnet
  ]
}

# Create a new Public Route Table to access Internet.
# This Route Table is routed via the Internet Gateway to achieve the same.
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

# Create a new Default (Private) Route Table which should not open to the Internet.
# For the private EC2 instances to receive OS patch instances from Internet, 
# they should be routed via NAT gateway to access the Internet.
# Note: NACLs & Security Groups can help more security to avoid attacks from Internet.
resource "aws_default_route_table" "sanjib_vpc_private_rt" {
  default_route_table_id  = aws_vpc.sanjib_vpc.default_route_table_id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.sanjib-natgw.id
  }

  tags = {
    Name = "sanjib_private_rt"
  }
}

# Create a association between the Public Route Table with the Public Subnet, such that Internet accessability will be easy.
resource "aws_route_table_association" "sanjib_public_assoc" {
  count          = length(aws_subnet.sanjib_public_subnet)
  subnet_id      = aws_subnet.sanjib_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.sanjib_vpc_public_rt.id
}

# Create a association between the Private Route Table with the Private Subnet, such that there is no Internet accessability.
resource "aws_route_table_association" "sanjib_private_assoc" {
  count          = length(aws_subnet.sanjib_private_subnet)
  subnet_id      = aws_subnet.sanjib_private_subnet.*.id[count.index]
  route_table_id = aws_vpc.sanjib_vpc.default_route_table_id
}