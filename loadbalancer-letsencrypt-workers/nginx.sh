#!/bin/bash

# updates and install
sudo apt-get update -y
sudo apt-get install nginx -y

# allow http
sudo ufw allow 'Nginx HTTP'

# enable services
sudo systemctl enable nginx
sudo systemctl start nginx