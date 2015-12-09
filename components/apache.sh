#!/bin/bash
# Set up Apache

# install apache
apt-get install -y apache2 apache2-mpm-worker libapache2-mod-fastcgi

# disable non-threaded php exec.
a2dismod mpm_prefork
# disable classic php exec.
a2dismod mod_php

a2enmod mpm_worker actions fastcgi alias

echo "****************** Creating Apache php conf file ******************"

cat <<EOF > /etc/apache2/conf-available/php5-fpm.conf
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

# Load php5-fpm config.
a2enconf php5-fpm

# Reload apache.
service apache2 reload

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

# enable mod_rewrite
a2enmod rewrite

# restart apache
service apache2 restart
