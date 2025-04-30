# Hướng dẫn sử dụng SSH Key để đăng nhập vào VPS

## 1. Tạo SSH Key (nếu chưa có)

Trên máy **local (máy bạn)**, mở Terminal và gõ:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Khi được hỏi lưu ở đâu → nhấn Enter (mặc định là `~/.ssh/id_ed25519`)
- Kết quả: tạo ra 2 file:
  - `~/.ssh/id_ed25519`: **private key**
  - `~/.ssh/id_ed25519.pub`: **public key**

---

## 2. Copy SSH Public Key lên VPS

Dùng lệnh sau (thay `username` và `ip_address` bằng thông tin VPS của bạn):

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@ip_address
```

> Lệnh này sẽ:
>
> - Tạo thư mục `~/.ssh` trên VPS (nếu chưa có)
> - Copy nội dung `id_ed25519.pub` vào `~/.ssh/authorized_keys` trên VPS

---

## 3. SSH vào VPS bằng Key

Giờ bạn có thể đăng nhập VPS mà không cần mật khẩu:

```bash
ssh username@ip_address
```

```bash
ssh -i ~/.ssh/key username@ip_address
```

> SSH sẽ tự dùng khóa `id_ed25519` mặc định để xác thực.

---

## 4. (Tùy chọn) Tắt đăng nhập bằng mật khẩu (chỉ dùng key)

Trên VPS, mở file cấu hình SSH:

```bash
sudo nano /etc/ssh/sshd_config
```

Tìm và sửa:

```
PasswordAuthentication no
PubkeyAuthentication yes
```

Sau đó **khởi động lại dịch vụ SSH**:

```bash
sudo systemctl restart ssh
```

> ⚠️ _Chỉ làm bước này nếu bạn đã chắc chắn đăng nhập được bằng SSH key, kẻo bị khóa luôn!_

---

## ✅ Tổng kết các lệnh

| Lệnh                                                       | Mục đích                    |
| ---------------------------------------------------------- | --------------------------- |
| `ssh-keygen -t ed25519 -C "your_email"`                    | Tạo SSH key                 |
| `ssh-copy-id -i ~/.ssh/id_ed25519.pub username@ip_address` | Copy public key lên VPS     |
| `ssh username@ip_address`                                  | Đăng nhập vào VPS bằng key  |
| `sudo nano /etc/ssh/sshd_config`                           | Tắt đăng nhập bằng mật khẩu |
| `sudo systemctl restart ssh`                               | Khởi động lại SSH service   |
