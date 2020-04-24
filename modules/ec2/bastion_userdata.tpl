#!/bin/bash
#############################
# Author : SANJIB BEHERA
# Version: SB_0.1
#############################
yum install telnet -y
yum install curl -y
yum install wget -y
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent