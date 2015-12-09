#!/bin/bash
# Set up MariaDB.

# Get MariaDB key.
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

# Add repository.
add-apt-repository 'deb [arch=amd64,i386] http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/debian main'

apt-get update

# Set password so it doesnt ask when installing.
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password_again password $PASSWORD"

# Install.
apt-get install mariadb-server
