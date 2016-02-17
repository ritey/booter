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
chown root:www-data "/var/www/$SITENAME/logs"

echo "****************** Updating server software ******************"

# update / upgrade
apt-get update
apt-get -y upgrade

# install additional software
apt-get install -y apache2 php5 makepasswd curl iptables php5-curl php5-mcrypt php5-gd php-pear php5-imagick build-essential openssl apt-show-versions libapache2-mod-evasive git

echo "****************** Enabling new site ******************"

a2ensite $SITENAME

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
memory_limit = 256M
post_max_size = 20M
upload_max_filesize = 20M
max_file_uploads = 6
EOF

echo "****************** Setting Custom Log Rotation Config ******************"

cat << FOE >> /etc/logrotate.d/apache2

/var/www/$SITENAME/logs/*.log {
	daily
	missingok
	rotate 14
	compress
	delaycompress
	notifempty
	create 640 root adm
	sharedscripts
	postrotate
                if /etc/init.d/apache2 status > /dev/null ; then \
                    /etc/init.d/apache2 reload > /dev/null; \
                fi;
	endscript
	prerotate
		if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
			run-parts /etc/logrotate.d/httpd-prerotate; \
		fi; \
	endscript
}
FOE

echo "****************** Reloading Apache ******************"

service apache2 restart

} # this ensures the entire script is downloaded #
