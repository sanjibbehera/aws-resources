# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY EC2 INSTANCE
# Author : SANJIB BEHERA
# Version: SB_0.1
# ---------------------------------------------------------------------------------------------------------------------

# Use the AMI as datasource used to create EC2 instance.
data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }
}

locals {
  module_path = replace(path.module, "\\", "/")
}

# create a Key Pair to be used to login EC2 Instance(s).
resource "aws_key_pair" "sanjib_key_auth" {
  key_name   = var.key_name
  public_key = file("${local.module_path}/../../keys/sshkey.pub")
}

# create the base AMI EC2 Instance(s).
resource "aws_instance" "base_ami_server" {
    count                  = var.baseami_instance_count
    ami                    = data.aws_ami.server_ami.id
    instance_type          = var.instance_type
    key_name               = var.key_name
    user_data              = file("${local.module_path}/baseami_userdata.tpl")
    subnet_id              = var.public_subnet_id[count.index]
    iam_instance_profile   = var.iam_instance_profile

    tags = {
      Name = "BASE AMI Instance-${count.index + 1}"
    }
}

# create the Bastion EC2 Instance(s).
resource "aws_instance" "bastion_servers" {
    count                  = var.bastion_instance_count
    ami                    = data.aws_ami.server_ami.id
    instance_type          = var.instance_type
    key_name               = var.key_name
    user_data              = file("${local.module_path}/bastion_userdata.tpl")
    subnet_id              = var.public_subnet_id[count.index]
    iam_instance_profile   = var.iam_instance_profile

    tags = {
      Name = "Bastion Instance-${count.index + 1}"
    }
}

# create the Apache Webserver EC2 Instance(s).
resource "aws_instance" "web_server" {
    count                  = var.instance_count
    ami                    = data.aws_ami.server_ami.id
    instance_type          = var.instance_type
    key_name               = var.key_name
    user_data              = file("${local.module_path}/userdata.tpl")
    subnet_id              = var.private_subnet_id[count.index]
    iam_instance_profile   = var.iam_instance_profile

    tags = {
      Name = "Test Instance-${count.index + 1}"
    }
}

# create the public security group for the Bastion EC2 Instance(s).
resource "aws_security_group" "sanjib_public_sg" {
  name        = "sanjib_public_sg"
  description = "Used for access to the Public Instances"
  vpc_id      = var.vpc_id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create the public security group for the Base AMI EC2 Instance(s).
resource "aws_security_group" "sanjib_public_baseami_sg" {
  name        = "sanjib_public_baseami_sg"
  description = "Used for access to the Public Instances"
  vpc_id      = var.vpc_id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  
  #TOMCAT PORT
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create the private security group for the Apache Webserver EC2 Instance(s).
resource "aws_security_group" "sanjib_private_sg" {
  name        = "sanjib_private_sg"
  description = "Security Groups in Private Instances"
  vpc_id      = var.vpc_id
}

# Create the Network Interface Security Group attachment for public Security Group.
resource "aws_network_interface_sg_attachment" "public_sg_attachment" {
    count                  = var.bastion_instance_count
    security_group_id      = aws_security_group.sanjib_public_sg.id
    network_interface_id   = aws_instance.bastion_servers[count.index].primary_network_interface_id
}

# Create the Network Interface Security Group attachment for public Security Group.
resource "aws_network_interface_sg_attachment" "public_baseami_sg_attachment" {
    count                  = var.baseami_instance_count
    security_group_id      = aws_security_group.sanjib_public_baseami_sg.id
    network_interface_id   = aws_instance.base_ami_server[count.index].primary_network_interface_id
}

# Create the Network Interface Security Group attachment for private Security Group.
resource "aws_network_interface_sg_attachment" "private_sg_attachment" {
    count                  = var.instance_count
    security_group_id      = aws_security_group.sanjib_private_sg.id
    network_interface_id   = aws_instance.web_server[count.index].primary_network_interface_id
}

# Adapt the Private Security Group Ingress Rule, source changed to security group of the Bastion EC2 Instance,
# such that Private EC2 Instances can only be reached by the Bastion EC2 Instances, hence blocking everybody else.
resource "aws_security_group_rule" "ssh_ingress_private_instances" {
  type                        = "ingress"
  from_port                   = 22
  to_port                     = 22
  protocol                    = "tcp"
  source_security_group_id    = aws_security_group.sanjib_public_sg.id
  security_group_id           = aws_security_group.sanjib_private_sg.id

  depends_on = [
      aws_security_group.sanjib_private_sg
  ]
}

# Adapt the Private Security Group Egress Rule, source changed to security group of the Bastion EC2 Instance,
# such that Private EC2 Instances can only be reached by the Bastion EC2 Instances, hence blocking everybody else.
resource "aws_security_group_rule" "ssh_egress_private_instances" {
  type                        = "egress"
  from_port                   = 0
  to_port                     = 0
  protocol                    = "-1"
  source_security_group_id    = aws_security_group.sanjib_public_sg.id
  security_group_id           = aws_security_group.sanjib_private_sg.id

  depends_on = [
      aws_security_group.sanjib_private_sg
  ]
}