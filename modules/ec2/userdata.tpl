#!/bin/bash
yum install httpd -y
yum install curl -y
private_address=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "This is Sanjib Behera. and the Private IP of the hosted Instance is ${private_address}" >> /var/www/html/index.html
service httpd start
chkconfig httpd on