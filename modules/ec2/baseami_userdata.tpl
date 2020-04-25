#!/bin/bash
yum update -y
yum install java-1.8.0-openjdk-devel -y
yum install wget -y
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
amazon-linux-extras install -y tomcat8.5