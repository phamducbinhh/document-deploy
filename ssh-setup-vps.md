
# 🧠 Hướng dẫn sử dụng SSH Key để đăng nhập vào VPS

## VPS: `vmadmin@ip_address`

---

## 1. Tạo SSH Key (nếu chưa có)

Trên **máy local**, mở Terminal và chạy:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Khi được hỏi nơi lưu → nhấn **Enter** để dùng mặc định `~/.ssh/id_ed25519`
- Kết quả:
  - `~/.ssh/id_ed25519`: **private key**
  - `~/.ssh/id_ed25519.pub`: **public key**

---
- copy public key vao authorized_keys vps -> ssh -i ~/.ssh/id_ed25519.pub vmadmin@ip_address (dang nhap vao vps)

## 2. (Tùy chọn) Tạo user mới trên VPS

> Khuyến khích KHÔNG dùng `root` hoặc user mặc định như `vmadmin` cho SSH chính.

Đăng nhập vào VPS bằng tài khoản gốc (có sẵn):

```bash
ssh vmadmin@ip_address
```

Sau đó, tạo user mới (ví dụ: `dev`):

```bash
sudo adduser dev
```

Thêm user mới vào nhóm `sudo` (nếu cần quyền root):

```bash
sudo usermod -aG sudo dev
```

---

## 3. Copy SSH Public Key lên VPS

Từ **máy local**, dùng lệnh sau (thay `dev` và `ip_address`):

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub dev@ip_address
```

> Lệnh này sẽ:
> - Tạo thư mục `~/.ssh` trên VPS (nếu chưa có)
> - Ghi public key vào `~/.ssh/authorized_keys`

---

## 4. SSH vào VPS bằng Key

Giờ bạn có thể đăng nhập:

```bash
ssh dev@ip_address
```

Hoặc chỉ định file key cụ thể:

```bash
ssh -i ~/.ssh/id_ed25519 dev@ip_address
```

---

## 5. (Tùy chọn) Cấu hình file `~/.ssh/config` (trên máy local)

Tạo hoặc sửa file:

```bash
nano ~/.ssh/config
```

Thêm cấu hình sau:

```bash
Host my-vps
  HostName ip_address
  User dev
  IdentityFile ~/.ssh/id_ed25519
```

> Sau đó, chỉ cần gõ:
>
> ```bash
> ssh my-vps
> ```

---

## 6. (Tùy chọn) Vô hiệu hóa đăng nhập bằng mật khẩu (chỉ dùng SSH Key)

⚠️ **Chỉ làm bước này nếu bạn đã xác thực thành công bằng key!**

Trên VPS:

```bash
sudo nano /etc/ssh/sshd_config
```

Tìm và chỉnh sửa (nếu chưa đúng):

```
PasswordAuthentication no
PubkeyAuthentication yes
```

Khởi động lại dịch vụ SSH:

```bash
sudo systemctl restart ssh
```

---

## ✅ Tổng kết các lệnh

| Lệnh                                                       | Mục đích                         |
| ---------------------------------------------------------- | -------------------------------- |
| `ssh-keygen -t ed25519 -C "email"`                         | Tạo SSH key                      |
| `ssh vmadmin@ip_address`                                   | Đăng nhập VPS lần đầu            |
| `sudo adduser dev`                                         | Tạo user mới                     |
| `sudo usermod -aG sudo dev`                                | Cho user mới quyền sudo          |
| `ssh-copy-id -i ~/.ssh/id_ed25519.pub dev@ip_address`      | Copy public key lên VPS          |
| `ssh dev@ip_address`                                       | Đăng nhập vào VPS bằng key       |
| `nano ~/.ssh/config`                                       | Cấu hình shortcut SSH            |
| `sudo nano /etc/ssh/sshd_config`                           | Vô hiệu hóa login bằng mật khẩu  |
| `sudo systemctl restart ssh`                               | Restart dịch vụ SSH              |
