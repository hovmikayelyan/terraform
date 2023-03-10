#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2 style='color: red;'> Build by Power of Terraform: IP > $myip <br>
Owner ${f_name} ${l_name} <br>
VERSION @2 <br>
Owner's Interests > 

%{for x in interests ~}
<p style='color: blue;'> ${x} </p> <br>
%{ endfor ~}

</h2>
</html>
EOF

systemctl start httpd
chkconfig httpd on