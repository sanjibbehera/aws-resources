#!/bin/bash
#############################
# Author : SANJIB BEHERA
# Version: SB_0.1
#############################
sleep 350
yum install httpd24 -y
yum install curl -y
private_address=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "This is Sanjib Behera. and the Private IP of the hosted Instance is ${private_address}" >> /var/www/html/index.html
service httpd start
chkconfig httpd on
yum install git -y
yum install wget -y
yum install -y php72 php72-mysqlnd
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php