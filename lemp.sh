#!/bin/bash

#######################################
# Bash script to install an LEMP stack in ubuntu

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Ask value for mysql root password
read -p 'db_root_password [secretpasswd]: ' db_root_password
echo

# Update system
sudo apt-get update -y

## Install Nginx
sudo apt install nginx -y
sudo systemctl enable nginx

# Install MySQL database server
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"
apt-get install mysql-server -y

## Install PHP
sudo systemctl install php php-fpm php-mysql -y

## Install PhpMyAdmin
sudo apt-get install phpmyadmin -y

 # Set Permissions
sudo chown -R www-data:www-data /var/www

 # Restart Nginx
sudo systemctl reload nginx