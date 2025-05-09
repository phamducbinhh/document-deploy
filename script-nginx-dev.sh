#!/bin/bash

# setup_nginx_oeg.sh - Script to setup Nginx with SSL for OEG domains
# Created: May 9, 2025

# Exit on any error
set -e

echo "========================================="
echo "      OEG Nginx Configuration Setup      "
echo "========================================="

# 1. Install Nginx
echo "[1/7] Installing Nginx..."
sudo apt update
sudo apt install -y nginx

# 2. Manage Nginx Service
echo "[2/7] Starting and enabling Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

# 3. Create SSL directory and certificate files
echo "[3/7] Setting up SSL certificates..."
sudo mkdir -p /etc/nginx/ssl

# Create certificate files
echo "Creating certificate files..."
if [ ! -f /etc/nginx/ssl/oeg.vn.crt ]; then
    echo "Please enter your SSL certificate content for oeg.vn.crt (press Ctrl+D when done):"
    sudo tee /etc/nginx/ssl/oeg.vn.crt
fi

if [ ! -f /etc/nginx/ssl/ssl.oeg.vn.key ]; then
    echo "Please enter your SSL key content for ssl.oeg.vn.key (press Ctrl+D when done):"
    sudo tee /etc/nginx/ssl/ssl.oeg.vn.key
fi

# Set proper permissions
sudo chmod 600 /etc/nginx/ssl/ssl.oeg.vn.key
sudo chmod 644 /etc/nginx/ssl/oeg.vn.crt

# 4. Configure Nginx for HTTPS
echo "[4/7] Creating Nginx configuration for OEG domains..."
sudo tee /etc/nginx/sites-available/local-dev.vn > /dev/null << 'EOF'
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    
    server_name local-esports.oeg.vn;
    ssl_certificate /etc/nginx/ssl/oeg.vn.crt;
    ssl_certificate_key /etc/nginx/ssl/ssl.oeg.vn.key;
    
    location / {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 1m;
        proxy_connect_timeout 1m;
        proxy_pass http://127.0.0.1:3001;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    
    server_name local.oeg.vn;
    ssl_certificate /etc/nginx/ssl/oeg.vn.crt;
    ssl_certificate_key /etc/nginx/ssl/ssl.oeg.vn.key;
    
    location / {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    
    server_name local-news.oeg.vn;
    ssl_certificate /etc/nginx/ssl/oeg.vn.crt;
    ssl_certificate_key /etc/nginx/ssl/ssl.oeg.vn.key;
    
    location / {
        proxy_pass http://localhost:3003;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    
    server_name local-profile.oeg.vn;
    ssl_certificate /etc/nginx/ssl/oeg.vn.crt;
    ssl_certificate_key /etc/nginx/ssl/ssl.oeg.vn.key;
    
    location / {
        proxy_pass http://localhost:3004;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name 192.168.1.28;
    
    location / {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# 5. Enable the site
echo "[5/7] Enabling the OEG sites configuration..."
sudo ln -sf /etc/nginx/sites-available/local-dev.vn /etc/nginx/sites-enabled/

# 6. Test and reload Nginx
echo "[6/7] Testing Nginx configuration..."
sudo nginx -t

echo "Reloading Nginx service..."
sudo systemctl reload nginx

# 7. Install and configure UFW firewall
echo "[7/7] Installing and configuring UFW firewall..."
sudo apt install -y ufw

echo "Configuring UFW and opening ports..."
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 80
sudo ufw allow 443

echo "Enabling UFW..."
sudo ufw --force enable

echo "Firewall configured and enabled successfully."

echo ""
echo "========================================="
echo "  OEG Nginx Setup Completed Successfully "
echo "========================================="
echo ""
echo "The following sites are now configured:"
echo "- https://local-esports.oeg.vn  -> localhost:3001"
echo "- https://local.oeg.vn          -> localhost:3002"
echo "- https://local-news.oeg.vn     -> localhost:3003"
echo "- https://local-profile.oeg.vn  -> localhost:3004"
echo "- http://192.168.1.28           -> localhost:3002"
echo ""
echo "Make sure to add these domains to your hosts file if needed:"
echo "sudo nano /etc/hosts"
echo "127.0.0.1 local-esports.oeg.vn local.oeg.vn local-news.oeg.vn local-profile.oeg.vn"
echo ""
