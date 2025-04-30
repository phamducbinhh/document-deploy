## Linux cơ bản

Tình trạng RAM: free -h
Tình trạng DISK: df -h
Tạo file: touch file.txt
Tạo thư mục: mkdir folder
Di chuyển: cd folder
Xem danh sách file: ls
Xem danh sách file ẩn: ls -a
Xem nội dung file: cat file.txt
Copy file: cp file.txt file2.txt
Xóa file: rm file.txt
Xóa thư mục: rm -r folder
Xóa folder và tất cả nội dung bên trong mà không cần xác nhận: rm -rf folder
Edit file: nano file.txt
kill all port 3000: lsof -i:3000 / kill -9 PID

# Kiểm tra trạng thái tường lửa (nếu bật thì sẽ show port mở)

sudo ufw status

# Bật tường lửa, nhưng cái này chỉ bật trong phiên làm việc hiện tại thôi, reboot là nó tự tắt

sudo ufw enable

# Yêu cầu tường lửa lên mỗi khi khởi động lại server

sudo systemctl enable ufw

# Mở port 22 (ssh), Nginx Full mở rồi không cần mở lại

sudo ufw allow ssh

# Mở port 3000

sudo ufw allow 3000

# restart ubuntu

sudo reboot

# Đóng port 4000

sudo ufw delete allow 4000

## Tăng 1GB Ram ảo

## Tạo một file swap mới:

sudo fallocate -l 1G /swapfile

# Thiết lập quyền truy cập cho file swap:

sudo chmod 600 /swapfile

# Đánh dấu file là một không gian swap:

sudo mkswap /swapfile

# Kích hoạt swap file:

sudo swapon /swapfile

# Mở file /etc/fstab để dán đoạn này vào `/swapfile swap swap defaults 0 0`

sudo nano /etc/fstab

# Xác nhận swap đã được kích hoạt:

sudo swapon --show
sudo free -h</code></pre>
