#!/bin/bash
sleep 400
yum install httpd -y
yum install curl -y
private_address=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "This is Sanjib Behera. and the Private IP of the hosted Instance is ${private_address}" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
yum install git -y
yum install wget -y
amazon-linux-extras install -y php7.2
echo '<?php print phpinfo();' | sudo tee --append /var/www/html/phpinfo.php
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent