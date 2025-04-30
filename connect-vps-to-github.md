# Kết nối VPS với GitHub qua SSH Key

Dưới đây là các bước giúp bạn cấu hình VPS để có thể **pull/push từ GitHub qua SSH**, không cần nhập username/password.

---

## ✅ Bước 1: Tạo SSH key trên VPS

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Khi được hỏi vị trí lưu, bạn có thể nhấn `Enter` để chọn mặc định (`~/.ssh/id_ed25519`)
- Sau khi hoàn tất, có 2 file được tạo:
  - `~/.ssh/id_ed25519` (private key)
  - `~/.ssh/id_ed25519.pub` (public key)

---

## ✅ Bước 2: Thêm SSH public key vào GitHub

1. Mở file public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
2. Copy nội dung.
3. Truy cập GitHub:
   - Settings → SSH and GPG Keys → New SSH key
   - Dán key vào và đặt tên gợi nhớ (ví dụ: "VPS Server")
4. Thêm dòng này

- eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519

---

## ✅ Bước 3: Kiểm tra kết nối từ VPS đến GitHub

```bash
ssh -T git@github.com
```

> Nếu thành công, sẽ thấy:
>
> ```
> Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
> ```

---

## ✅ Bước 4: Clone repository bằng SSH

```bash
git clone git@github.com:<username>/<repo>.git
```

> ⚠️ Phải dùng URL dạng `git@github.com:username/repo.git` thay vì HTTPS.

---

## ✅ Bước 5: Cấu hình Git (nếu cần)

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

---

## 📌 Ghi chú

- Đảm bảo thư mục `~/.ssh` có quyền truy cập phù hợp:

  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
  ```

- Nếu bạn dùng nhiều SSH key, có thể tạo file `~/.ssh/config` để quản lý:

```bash
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
```

---

## 🧪 Kiểm tra nhanh

```bash
ssh -T git@github.com
```

Nếu hiển thị “successfully authenticated” → Đã kết nối thành công.
