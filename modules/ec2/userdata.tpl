#!/bin/bash
yum install httpd -y
echo "This is Sanjib Behera." >> /var/www/html/index.html
service httpd start
chkconfig httpd on