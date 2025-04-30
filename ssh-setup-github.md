# Hướng dẫn tạo SSH Key và cấu hình SSH để kết nối GitHub

## 1. Kiểm tra thư mục `.ssh`

Mở Terminal và chạy lệnh:

```bash
ls -la ~/.ssh
```

Nếu chưa có, bạn sẽ tạo mới sau.

---

## 2. Tạo SSH Key

Chạy lệnh sau để tạo SSH key (sử dụng email GitHub của bạn):

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Khi được hỏi lưu ở đâu, nhập: `~/.ssh/github` (hoặc để mặc định)
- Nhấn `Enter` để tiếp tục, có thể đặt passphrase hoặc để trống.

Kết quả: Tạo ra 2 file:

- `~/.ssh/github`: Private key
- `~/.ssh/github.pub`: Public key

---

## 3. Thêm SSH Key vào ssh-agent

Khởi động ssh-agent và thêm key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
```

---

## 3.1 Tạo thư mục .ssh (nếu chưa tồn tại)

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

---

## 3.2 Tạo file config

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
```

---

## 4. Cấu hình SSH với GitHub

Mở hoặc tạo file cấu hình:

```bash
nano ~/.ssh/config
```

Thêm nội dung sau:

```ssh
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github
```

> Giúp SSH biết nên dùng key nào khi kết nối tới GitHub.

---

## 5. Thêm SSH key vào tài khoản GitHub

1. Chạy lệnh sau để copy public key:

   ```bash
   cat ~/.ssh/github.pub
   ```

2. Vào GitHub → **Settings** → **SSH and GPG keys**
3. Nhấn **New SSH key**, dán key vừa copy, đặt tên và lưu lại.

---

## 6. Kiểm tra kết nối với GitHub

Chạy lệnh sau:

```bash
ssh -T git@github.com
```

Kết quả thành công:

```
Hi your-username! You've successfully authenticated...
```

---

## 7. Clone repository bằng SSH

Thay vì dùng HTTPS, bạn clone bằng SSH:

```bash
git clone git@github.com:username/repo-name.git
```

---

## ✅ Tổng kết lệnh

| Lệnh                               | Mục đích                 |
| ---------------------------------- | ------------------------ |
| `ssh-keygen -t ed25519 -C "email"` | Tạo SSH key              |
| `ssh-add ~/.ssh/github`            | Thêm key vào agent       |
| `cat ~/.ssh/github.pub`            | Lấy public key           |
| `ssh -T git@github.com`            | Kiểm tra kết nối         |
| `nano ~/.ssh/config`               | Cấu hình key theo domain |
