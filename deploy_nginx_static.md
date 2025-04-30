# Hướng dẫn cấu hình Nginx để deploy HTML/CSS tĩnh

## 🧩 MỤC TIÊU CHUNG

Deploy một website tĩnh (`index.html`, CSS, ảnh...) bằng Nginx và có thể truy cập qua domain ảo `http://dev-static.com`.

---

## 🔷 I. TRIỂN KHAI TRÊN WSL (Chạy trên máy Windows nội bộ)

### ✅ Bước 1: Cài đặt Nginx trong WSL

```bash
sudo apt update
sudo apt install nginx
```

### ✅ Bước 2: Tạo thư mục chứa web tĩnh

```bash
sudo mkdir -p /var/www/dev-static/html
sudo cp -r ./your-static-files/* /var/www/dev-static/html
```

### ✅ Bước 3: Cấu hình Nginx

Tạo file cấu hình:

```bash
sudo nano /etc/nginx/sites-available/dev-static
```

Nội dung:

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

Bật site:

```bash
sudo ln -s /etc/nginx/sites-available/dev-static /etc/nginx/sites-enabled/
```

Kiểm tra và restart:

```bash
sudo nginx -t
sudo service nginx restart
```

### ✅ Bước 4: Trỏ domain `dev-static.com` về localhost trong Windows

Sửa file `C:\Windows\System32\drivers\etc\hosts`:

```
127.0.0.1 dev-static.com
```

### 🛠 Nếu dùng WSL2 (mạng riêng biệt): ánh xạ cổng

Trong PowerShell (Admin):

```powershell
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=WSL_IP
```

Lấy WSL_IP bằng:

```bash
ip addr | grep inet
```

---

## 🔶 II. TRIỂN KHAI TRÊN VPS (Máy chủ từ xa thật)

### ✅ Bước 1: Cài Nginx

```bash
sudo apt update
sudo apt install nginx
```

### ✅ Bước 2: Tạo thư mục và copy file

```bash
sudo mkdir -p /var/www/dev-static/html
sudo cp -r /home/dev/deploy-portfolio/dist/* /var/www/dev-static/html
```

### ✅ Bước 3: Cấu hình Nginx

Tạo file:

```bash
sudo nano /etc/nginx/sites-available/dev-static
```

Nội dung:

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

Bật site:

```bash
sudo ln -s /etc/nginx/sites-available/dev-static /etc/nginx/sites-enabled/
sudo nginx -t
sudo service nginx restart
```

### ✅ Bước 4: Trỏ domain trên **máy Windows** về IP thật của VPS

Sửa file `hosts` trên Windows:

```plaintext
103.140.249.25 dev-static.com  (IP thật của VPS)
```

(Lưu ý: dùng IP thật của VPS bạn)

### ✅ Bước 5: (Tuỳ chọn) cập nhật `/etc/hosts` trong VPS

Mở file:

```bash
sudo nano /etc/hosts
```

thêm dòng này vào file mới ping domain `dev-static.com`:

```plaintext
103.140.249.25 dev-static.com
```

---

## 🔍 KIỂM TRA SAU CÙNG

| Kiểm tra                                          | Môi trường        |
| ------------------------------------------------- | ----------------- |
| `curl http://dev-static.com`                      | Trên WSL hoặc VPS |
| Truy cập `http://dev-static.com` trên trình duyệt | Trên máy Windows  |
