#!bin/bash

ipaddr=$(/sbin/ifconfig eth0) ; ipaddr=${ipaddr/*inet addr:/} ipaddr=${ipaddr/ */}
echo "$ipaddr"

LIST_OF_APPS="httpd mod_ssl"

yum update -y \
	&& yum -y install $LIST_OF_APPS

mkdir -p /apps/hello-http/html \
	&& cp ./hello.html /apps/hello-http/html/ \
	&& cp ./ssl.conf /etc/httpd/conf.d/

service httpd start \
	&& service httpd status

curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://ec2-52-53-248-207.us-west-1.compute.amazonaws.com/hello.html
