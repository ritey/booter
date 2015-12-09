#!/bin/bash
# Set up PHP-FPM.

apt-get install php5-fpm php5-mysql php5-curl php5-mcrypt php5-gd php-pear php5-imagick

echo "****************** Editing PHP config ******************"

cat <<EOF > /etc/php5/apache2/conf.d/extra.ini
memory_limit = 256MB
post_max_size = 20MB
upload_max_filesize = 20MB
max_file_uploads = 6
EOF
