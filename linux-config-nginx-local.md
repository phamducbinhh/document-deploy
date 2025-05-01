# Hướng Dẫn Cấu Hình Nginx local

## 🧩 MỤC TIÊU CHUNG

Cấu hình Nginx trên Ubuntu để chạy ứng dụng ReactJS qua HTTPS với domain ảo https://local-dev.vn, proxy yêu cầu đến localhost:3000.

---

## 1. Cài Đặt Nginx

### Ubuntu / Debian / WSL

```bash
sudo apt update
sudo apt install nginx
```

### CentOS / RHEL

```bash
sudo yum install epel-release
sudo yum install nginx
```

---

## 2. Quản Lý Dịch Vụ Nginx

```bash
sudo systemctl start nginx           # Bắt đầu dịch vụ
sudo systemctl enable nginx          # Khởi động cùng hệ thống
sudo systemctl restart nginx         # Khởi động lại
sudo systemctl reload nginx          # Tải lại cấu hình
sudo systemctl status nginx          # Kiểm tra trạng thái
```

---

## 3. Cấu Trúc Thư Mục Mặc Định

```bash
/etc/nginx/
├── nginx.conf                # File cấu hình chính
├── sites-available/         # Chứa các file cấu hình website
├── sites-enabled/           # Symlink đến site đang kích hoạt
├── conf.d/                  # Cấu hình bổ sung (autoload)
```

---

### Bước 4. Cấu Hình Nginx cho HTTPS

```bash
sudo nano /etc/nginx/sites-available/local-dev.vn
```

**Nội dung:**

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name local.oeg.vn;
    ssl_certificate    /etc/nginx/ssl/oeg.vn.crt;
    ssl_certificate_key /etc/nginx/ssl/ssl.oeg.vn.key;

    location / {
       proxy_redirect                      off;
        proxy_set_header Host               $host;
        proxy_set_header X-Real-IP          $remote_addr;
        proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto  $scheme;
        proxy_read_timeout          1m;
        proxy_connect_timeout       1m;
        proxy_pass                          http://localhost:3002;
    }
}

server {
    listen 80;
    listen [::]:80;
    server_name local.oeg.vn;
    return 301 https://$host$request_uri;
}

```

### Bước 4: Kích hoạt site

```bash
sudo ln -s /etc/nginx/sites-available/local-dev.vn /etc/nginx/sites-enabled/
```

### Bước 5: Cấu hình domain local

```bash
sudo nano /etc/hosts
```

**Nội dung:**
```nginx
127.0.0.1 local-dev.vn
```

### Bước 5: Kiểm tra và reload Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Bước 6. Một Số Lưu Ý Khác

- Port 80/443

```bash
sudo ufw allow 80
sudo ufw allow 443
```


---

## ✅ Kiểm Tra

Truy cập vào:

- **Ubuntu:** https://local-dev.vn trong browser

---
