#!/bin/bash

# Prompt user for domain name and configuration file name
read -p "Enter your domain name: " domain_name
read -p "Enter your configuration file name (without spaces): " config_name

# Define file paths
CONFIG_FILE="/etc/nginx/sites-available/$config_name"
WEB_DIR="/var/www/$config_name"

# Update and upgrade packages
echo "Updating and upgrading packages..."
apt update && apt upgrade -y

# Install nginx
echo "Installing nginx..."
apt install -y nginx

# Create nginx site configuration
echo "Creating nginx configuration at $CONFIG_FILE"
cat << EOF > "$CONFIG_FILE"
server {
    listen 80 ;
    listen [::]:80 ;
    server_name $domain_name ;
    root $WEB_DIR ;
    index index.html index.htm index.nginx-debian.html ;
    location / {
            try_files \$uri \$uri/ =404 ;
    }
}
EOF

# Create website directory and index file
echo "Creating website directory at $WEB_DIR and index file"
mkdir -p "$WEB_DIR"
cat << EOF > "$WEB_DIR/index.html"
<!DOCTYPE html>
<html>
<head>
    <title>My Website</title>
</head>
<body>
    <h1>My website!</h1>
    <p>This is my website. Thanks for stopping by!</p>
    <p>Now my website is live!</p>
</body>
</html>
EOF

# Enable site and reload nginx
echo "Enabling site and reloading nginx"
ln -s "$CONFIG_FILE" /etc/nginx/sites-enabled/
systemctl reload nginx

echo "Setup complete!"
