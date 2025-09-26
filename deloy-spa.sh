#!/bin/bash
APP_DIR=/home/dev/app-production/protected-room-fe
WEB_ROOT=/var/www/quanlynhatro.grpnext.id.vn

cd $APP_DIR

# Lấy code mới (nếu có git)
git pull

# Cài lại package nếu cần
npm ci || npm install

# Build
npm run build

# Copy build sang web root
sudo rm -rf $WEB_ROOT/*
sudo cp -R build/client/* $WEB_ROOT/
sudo chown -R www-data:www-data $WEB_ROOT

# Reload Nginx
sudo systemctl reload nginx

echo "✅ Deploy thành công!"
