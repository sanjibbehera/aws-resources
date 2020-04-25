# ---------------------------------------------------------------------------------------------------------------------
# CREATE AMI FROM EC2 Instance..
# Author : SANJIB BEHERA
# Version: SB_0.1
# ---------------------------------------------------------------------------------------------------------------------

# Create AMI from EC2 Instance..
resource "aws_ami_from_instance" "sanjib-ami" {
    count            = 1
    name               = "sanjib-ami"
    source_instance_id = var.source_instance_id[count.index]
  tags = {
      Name = "sanjib-ami-eg"
  }
}