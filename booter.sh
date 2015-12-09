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

# Check server to install.
# Default to apache.
if [ -z "$SERVER" ] || [ $SERVER != "apache" ] || [ $SERVER != "nginx" ]; then
  SERVER="apache"
fi

# Common tasks for both servers.
echo "****************** Install prerequisites ******************"
# software-properties-common - for apt-key command;
# lsb_release package - to get codename;
# git-core - to clone stuff from git;
apt-get install software-properties-common lsb-release git-core curl iptables  build-essential openssl apt-show-versions libapache2-mod-evasive -y

# Get Debian codename.
CODENAME="$(lsb_release -sc)"

# Export vars to external scripts.
export CODENAME
export PASSWORD
export IPADDRESS
export DOMAIN
export SITENAME

echo "****************** Creating site folder ******************"

# create project folder
mkdir "/var/www/$SITENAME/"
mkdir "/var/www/$SITENAME/logs"
chown www-data:www-data "/var/www/$SITENAME/logs"

echo "****************** Updating server software ******************"

# update / upgrade
apt-get update
apt-get -y upgrade

echo "****************** Installing MySql software ******************"

sh ./components/mysql.sh

echo "****************** Installing Composer software ******************"

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "****************** Setting up IPTABLES ******************"

sh ./components/firewall.sh

# Apache install instructions.
if [ SERVER == 'apache' ]; then

sh ./components/apache.sh

# Nginx install instructions.
elif [ SERVER == 'nginx' ]; then

sh ./components/nginx.sh

fi
} # this ensures the entire script is downloaded #
