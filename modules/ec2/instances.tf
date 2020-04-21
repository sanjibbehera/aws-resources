# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

locals {
  module_path = replace(path.module, "\\", "/")
}

resource "aws_key_pair" "sanjib_key_auth" {
  key_name   = var.key_name
  public_key = file("${local.module_path}/../../keys/sshkey.pub")
}

resource "aws_instance" "web_server" {
    count                  = var.instance_count
    ami                    = data.aws_ami.server_ami.id
    instance_type          = var.instance_type
    key_name               = var.key_name
    user_data              = file("${local.module_path}/userdata.tpl")
    subnet_id              = var.subnet_id[count.index]

    tags = {
      Name = "Test Instance-${count.index + 1}"
    }
}

resource "aws_security_group" "sanjib_public_sg" {
  name        = "sanjib_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = var.vpc_id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

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

resource "aws_network_interface_sg_attachment" "sg_attachment" {
    count                  = var.instance_count
    security_group_id      = aws_security_group.sanjib_public_sg.id
    network_interface_id   = aws_instance.web_server[count.index].primary_network_interface_id
}