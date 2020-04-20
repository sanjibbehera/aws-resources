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
  #vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = file("${local.module_path}/userdata.tpl")
}