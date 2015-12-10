#!/bin/bash
# Set up PHP-FPM.

# PHP_PATH used to determine file paths. Defaults to php5
PHP_PATH="/etc/php5/fpm"

# Install PHP-FPM 5.6
if [ $PHP = "5.6" ]; then

apt-get install -y php5-fpm php5-mysql php5-curl php5-mcrypt php5-gd php-pear

# Install PHP-FPM 7.0
elif [ $PHP = "7.0" ]; then

# Change path to php7.0-fpm specific.
PHP_PATH="/etc/php/7.0/fpm"

# Add www.dotdeb.org repository.
# add key
wget https://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg

# add repository
add-apt-repository 'deb http://mirror.mscott.me.uk/dotdeb/ stable all'

apt-get update

# No php-pearl as of 10/12/2015
apt-get install -y php7.0-fpm php7.0-mysql php7.0-curl php7.0-mcrypt php7.0-gd

fi

echo "****************** Editing PHP config ******************"

cat <<EOF > $PHP_PATH/conf.d/extra.ini
memory_limit = 256M
post_max_size = 20M
upload_max_filesize = 20M
max_file_uploads = 6
EOF

# backup php.ini file.
cp "$PHP_PATH/php.ini" "$PHP_PATH/php.ini.backup"

# modify php5-fpm config file:
# change default (=1)
# ;cgi.fix_pathinfo=1
# to
# cgi.fix_pathinfo=0
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" "$PHP_PATH/php.ini"

# Start php-fpm.
if [ $PHP = "5.6" ]; then
  service php5-fpm start
elif [ $PHP = "7.0" ]; then
  service php7.0-fpm start
fi
