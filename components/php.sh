#!/bin/bash
# Set up PHP-FPM.

apt-get install php5-fpm php5-mysql php5-curl php5-mcrypt php5-gd php-pear php5-imagick -y

echo "****************** Editing PHP config ******************"

cat <<EOF > /etc/php5/fpm/conf.d/extra.ini
memory_limit = 256M
post_max_size = 20M
upload_max_filesize = 20M
max_file_uploads = 6
EOF

# backup php.ini file.
cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.backup

# modify php5-fpm config file.
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

# Restart php5-fpm.
service php5-fpm restart
