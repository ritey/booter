#!/bin/bash

{ # this ensures the entire script is downloaded #

if [ -z "$SITENAME" ]; then
  SITENAME="website"
fi

if [ -z "$DOMAIN" ]; then
  DOMAIN="website"
fi

if [ -z "$PASSWORD" ]; then
  PASSWORD='123456789!'
fi

if [ -z "$IPADDRESS" ]; then
  IPADDRESS=""
fi


echo "****************** Creating Apache conf file ******************"

cat <<EOF > /etc/apache2/sites-available/$SITENAME.conf
<VirtualHost *:80>
	Servername $DOMAIN
	DocumentRoot "/var/www/$SITENAME/webroot/"
	DirectoryIndex index.php

	<Directory />
		Options +FollowSymLinks -Indexes
		AllowOverride All
	</Directory>

	LogLevel warn
	ErrorLog /var/www/$SITENAME/logs/error.log
	CustomLog /var/www/$SITENAME/logs/access.log combined
</VirtualHost>
EOF

echo "****************** Creating site folder ******************"

# create project folder
mkdir "/var/www/$SITENAME/"
mkdir "/var/www/$SITENAME/logs"
chown www-data:www-data "/var/www/$SITENAME/logs"

echo "****************** Enabling new site ******************"

a2ensite $SITENAME

echo "****************** Updating server software ******************"

# update / upgrade
apt-get update
apt-get -y upgrade

# install apache 2.5 and php 5.5
apt-get install -y apache2 php5 curl iptables php5-curl php5-mcrypt php5-gd php-pear php5-imagick build-essential openssl apt-show-versions libapache2-mod-evasive git

echo "****************** Installing MySql software ******************"

# install mysql and give password to installer
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
apt-get -y install mysql-server
apt-get install php5-mysql

# enable mod_rewrite
a2enmod rewrite

# restart apache
service apache2 restart

echo "****************** Installing Composer software ******************"

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "****************** Setting up IPTABLES ******************"

if [ -n "$IPADDRESS" ]; then
iptables -A INPUT -p tcp -s $IPADDRESS --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
else
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
fi
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A INPUT -p udp --dport 111 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 24007:24011 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -j REJECT
iptables -A FORWARD -j REJECT

iptables-save > /etc/iptables.rules

echo "****************** Editing PHP config ******************"

cat <<EOF > /etc/php5/apache2/conf.d/extra.ini
memory_limit = 256MB
post_max_size = 20MB
upload_max_filesize = 20MB
max_file_uploads = 6
EOF

echo "****************** Reloading Apache ******************"

service apache2 restart

} # this ensures the entire script is downloaded #
