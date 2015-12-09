#!/bin/bash
# Set up nginx

# Download and install nginx repo key.
wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add -

# Add repository.
add-apt-repository "http://nginx.org/packages/debian/ $CODENAME nginx"

# Update system repos with nginx.
apt-get update

# Install nginx.
apt-get install nginx-extras -y

# Use Persusio Drupal NGINX configuration.
# https://github.com/perusio/drupal-with-nginx

# Backup original nginx folder.
mv /etc/nginx /etc/nginx.old

# get the nginx files from repo.
git clone https://github.com/perusio/drupal-with-nginx.git /etc/nginx

# create sites-enabled folder
mkdir "/etc/nginx/sites-enabled"

# Create site configuration.
cp "/etc/nginx/sites-available/example.com.conf" "/etc/nginx/sites-available/$SITENAME.conf"
