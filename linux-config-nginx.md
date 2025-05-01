# Hướng Dẫn Cấu Hình và Deploy Website Với Nginx (Ubuntu / WSL / VPS)

## 🧩 MỤC TIÊU CHUNG

Deploy một website tĩnh (`index.html`, CSS, ảnh...) bằng Nginx và có thể truy cập qua domain ảo `http://myapp.local`.

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

## 4. Deploy Website (VD: `myapp.local`)

### Bước 1: Tạo thư mục chứa source code

```bash
sudo mkdir -p /var/www/myapp
sudo chown -R $USER:$USER /var/www/myapp
```

### ✅ Bước 2: Tạo thư mục chứa web tĩnh

```bash
sudo mkdir -p /var/www/myapp/html
sudo cp -r ./myapp/* /var/www/myapp/html
```

### Bước 3: Tạo file cấu hình website

```bash
sudo nano /etc/nginx/sites-available/myapp
```

**Nội dung:**

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/dev-static/html;
    index index.html;

    server_name dev-static.com;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Bước 4: Kích hoạt site

```bash
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
```

### Bước 5: Kiểm tra và reload Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 6. Cấu Hình Domain (Trên WSL hoặc VPS)

### Nếu dùng VPS:

- Trỏ domain (VD: `myapp.com`) về IP VPS qua DNS.

### Nếu dùng WSL / Local:

- Sửa file `/etc/hosts` hoặc `C:\Windows\System32\drivers\etc\hosts` (trên Windows)

```plaintext
127.0.0.1 myapp.local
```

---

## 7. (Tuỳ Chọn) Cài Đặt SSL Miễn Phí với Let’s Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d myapp.com
```

Tự động gia hạn:

```bash
sudo systemctl status certbot.timer
```

---

## 8. Theo Dõi Log Website

```bash
tail -f /var/log/nginx/myapp.access.log
tail -f /var/log/nginx/myapp.error.log
```

---

## 9. Một Số Lưu Ý Khác

- Port 80/443 phải được mở trên firewall (nếu dùng VPS).
- Nếu dùng PHP, cần cài thêm:

```bash
sudo apt install php php-fpm
```

- Static file (HTML/CSS/JS) không cần PHP-FPM.

---

## ✅ Kiểm Tra

Truy cập vào:

- **WSL:** http://myapp.local (nhớ sửa file `hosts`)
- **VPS:** http://your-domain.com hoặc http://your-ip

---
