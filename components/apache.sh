#!/bin/bash
# Set up Apache

# install apache
apt-get install -y apache2 apache2-mpm-worker libapache2-mod-fastcgi

# disable non-threaded php exec.
a2dismod mpm_prefork mod_php

# enable modules.
a2enmod mpm_worker actions fastcgi alias rewrite

echo "****************** Creating Apache php conf file ******************"

if [ $PHP = "5.6" ]; then

cat <<EOF > /etc/apache2/conf-available/php-fpm.conf
<IfModule mod_fastcgi.c>
    AddHandler php5-fcgi .php
    Action php5-fcgi /php5-fcgi
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
</IfModule>

<Directory /usr/lib/cgi-bin>
    Require all granted
</Directory>
EOF

else

cat <<EOF > /etc/apache2/conf-available/php-fpm.conf
<IfModule mod_fastcgi.c>
    AddHandler php7.0-fcgi .php
    Action php7.0-fcgi /php7.0-fcgi
    Alias /php7.0-fcgi /usr/lib/cgi-bin/php7.0-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php7.0-fcgi -socket /var/run/php/php7.0-fpm.sock -pass-header Authorization
</IfModule>

<Directory /usr/lib/cgi-bin>
    Require all granted
</Directory>
EOF

fi

# Load php-fpm config.
a2enconf php-fpm

# Create website config.
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

echo "****************** Enabling new site ******************"

a2ensite $SITENAME

# restart apache
service apache2 restart
