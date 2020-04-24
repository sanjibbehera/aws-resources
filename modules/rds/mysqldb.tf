# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY EC2 INSTANCE
# Author : SANJIB BEHERA
# Version: SB_0.1
# ---------------------------------------------------------------------------------------------------------------------

# RDS Security Group to be attached to RDS Instance.
data "aws_vpc" "rds_vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "rds_subnets" {
  vpc_id = data.aws_vpc.rds_vpc.id
}

# create new Security Group for the MYSQL DB.
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security Groups in Private Instances"
  vpc_id      = data.aws_vpc.rds_vpc.id

  # Opening MYSQL Port
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${var.privateEC2InstanceSG}"]
  }
}

resource "aws_db_subnet_group" "sanjib_rds_grp" {
  name       = "sanjib-rds-grp"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "SANJIB MYSQLDB Subnet Group"
  }
}


# Creating the RDS Instance.
resource "aws_db_instance" "sanjib_mysqldb" {
  identifier             = "sanjib-rds-mysqldb"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "sanjibdb"
  username               = "root"
  password               = var.RDS_PASSWORD
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  
  #subnet_ids             = data.aws_subnet_ids.rds_subnets.ids
  db_subnet_group_name   = aws_db_subnet_group.sanjib_rds_grp.id
  multi_az               = "false" # set to true to have high availability: 2 instances synchronized with each other

  tags = {
    Name = "SANJIB MYSQL DB"
  }
}

resource "aws_db_parameter_group" "sanjib-rds-dbpg" {
  name   = "sanjib-rds-dbpg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}