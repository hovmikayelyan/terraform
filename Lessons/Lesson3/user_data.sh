#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1 style='color: blue;'>Hello world from external script > $(hostname -f) > WebServer > IP: $myip <br> Build By TF </h1>" > /var/www/html/index.html
systemctl start httpd
chkconfig httpd on