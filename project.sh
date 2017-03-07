#!bin/bash

ipaddr=$(/sbin/ifconfig eth0) ; ipaddr=${ipaddr/*inet addr:/} ipaddr=${ipaddr/ */}
echo "$ipaddr"

LIST_OF_APPS="httpd mod_ssl"

yum update -y \
	&& yum -y install $LIST_OF_APPS
	
sed "s/ServerName.*/ServerName www.localhost.com:443/" ./ssl.conf \

	&& sed "s/TransferLog.*/TransferLog /var/log/weblogs/http.log" ./ssl.conf


mkdir -p /apps/hello-http/html \
	&& mkdir -p /var/log/weblogs \
	&& cp ./hello.html /apps/hello-http/html/ \
	&& cp ./ssl.conf /etc/httpd/conf.d/ \
	&& cp ./httpd.conf /etc/httpd/conf/

service httpd start \
	&& service httpd status

curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost/hello.html
