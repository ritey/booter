# booter
Bootscript for setting up a new box

Simply run
wget -qO- https://github.com/ritey/booter/archive/master.zip | unzip -
chmod +x booter-master/ -R
cd booter-master
sh booter.sh

Argument options include:

1. SITENAME="website"
2. DOMAIN="website"
3. PASSWORD='123456789!'
4. IPADDRESS="YOUR FIXED IPADDRESS"
5. PHP="5.6|7.0"
6. DRUSH
7. SERVER="apache|nginx"

For example:

wget -qO- https://github.com/ritey/booter/archive/master.zip | unzip -
chmod +x booter-master/ -R
cd booter-master

sh booter.sh SITENAME=GitHub DOMAIN=github.com PASSWORD=password123
sh booter.sh SITENAME=GitHub DOMAIN=github.com PASSWORD=password123 PHP=7.0 DRUSH
sh booter.sh SITENAME=GitHub DOMAIN=github.com PASSWORD=password123 SERVER=nginx PHP=7.0 DRUSH

## Arguments

### SITENAME

Used to name the apache configuration file and create the folder name for your website to reside in

### DOMAIN

The domain to be used to access the website

### Password

Used to to set the root password for MySQL

### IPADDRESS (optional)

Used in the firewall rule to limit SSH access to only the specified IP address

### PHP (optional)

Specify which PHP version to install. Can be either 5.6 (default) or 7.0

### DRUSH

If added DRUSH to command, drush will be installed.

### SERVER

Specify which server to use. Can be either apache (default) or nginx (not implemented fully).


