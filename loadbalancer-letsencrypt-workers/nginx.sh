#!/bin/bash

# updates and install
sudo apt-get update -y
sudo apt-get install nginx -y

# allow http
sudo ufw allow 'Nginx HTTP'

# enable services
sudo systemctl enable nginx
sudo systemctl start nginx

# nginx configuration
echo "Welcome to $(curl http://169.254.169.254/metadata/v1/hostname)!" > /var/www/html/index.nginx-debian.html
