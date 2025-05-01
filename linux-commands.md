## --- THÔNG TIN HỆ THỐNG ---
# Kiểm tra RAM
free -h

# Kiểm tra ổ đĩa
df -h

# Kiểm tra swap đang hoạt động
sudo swapon --show
sudo free -h

## --- QUẢN LÝ FILE & THƯ MỤC ---
# Tạo file và thư mục
touch file.txt
mkdir folder

# Di chuyển vào thư mục
cd folder

# Xem danh sách file
ls
ls -a         # Bao gồm file ẩn

# Xem nội dung file
cat file.txt

# Chỉnh sửa file
nano file.txt

# Copy, xóa file
cp file.txt file2.txt
rm file.txt

# Xóa thư mục (và tất cả nội dung)
rm -r folder
rm -rf folder    # Không cần xác nhận

## --- MẠNG & PORT ---
# Kill tiến trình dùng port 3000
lsof -i:3000
kill -9 PID

## --- TƯỜNG LỬA UFW ---
# Kiểm tra trạng thái UFW
sudo ufw status

# Bật UFW (tạm thời)
sudo ufw enable

# Tự động bật UFW khi khởi động
sudo systemctl enable ufw

# Mở port
sudo ufw allow ssh     # Port 22
sudo ufw allow 3000    # Port 3000

# Đóng port
sudo ufw delete allow 4000

## --- HỆ THỐNG ---
# Khởi động lại máy
sudo reboot

## --- TẠO SWAP (RAM ẢO) ---
# Tạo và kích hoạt 1GB swap
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Gắn vào fstab để tự động bật khi reboot
sudo nano /etc/fstab
# Thêm dòng sau vào cuối file:
/swapfile swap swap defaults 0 0
