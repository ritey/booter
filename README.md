# booter
Bootscript for setting up a new box

Simply run
wget -qO- https://raw.githubusercontent.com/ritey/booter/master/booter.sh | bash

Argument options include:

1. SITENAME="website"
2. DOMAIN="website"
3. PASSWORD='123456789!'
4. IPADDRESS="YOUR FIXED IPADDRESS"

For example:

wget -qO- https://raw.githubusercontent.com/ritey/booter/master/booter.sh | SITENAME=GitHub DOMAIN=github.com PASSWORD=password123 bash


## Arguments

### SITENAME

Used to name the apache configuration file and create the folder name for your website to reside in

### DOMAIN

The domain to be used to access the website

### Password

Used to to set the root password for MySQL

### IPADDRESS (optional)

Used in the firewall rule to limit SSH access to only the specified IP address