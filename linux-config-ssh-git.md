
# Cấu hình SSH Key cho GitHub và GitLab trên Linux

## 1. Kiểm tra và tạo thư mục `.ssh`

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ls -la ~/.ssh
```

---

## 2. Tạo SSH Key cho GitHub và GitLab

Tạo SSH key riêng biệt cho từng nền tảng:

```bash
# GitHub
ssh-keygen -t ed25519 -C "youremail@github.com" -f ~/.ssh/github

# GitLab
ssh-keygen -t ed25519 -C "youremail@gitlab.com" -f ~/.ssh/gitlab
```

> Có thể đặt passphrase hoặc để trống tùy ý.

---

## 3. Thêm SSH key vào ssh-agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
ssh-add ~/.ssh/gitlab
```

---

## 4. Tạo và chỉnh sửa file cấu hình SSH

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```

**Nội dung file `~/.ssh/config`:**

```ssh
# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes

# GitLab
Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile ~/.ssh/gitlab
  IdentitiesOnly yes
```

---

## 5. Thêm public key vào GitHub & GitLab

### Lấy nội dung public key:

```bash
cat ~/.ssh/github.pub     # Với GitHub
cat ~/.ssh/gitlab.pub     # Với GitLab
```

### Thêm vào tài khoản:

- **GitHub**: Settings → SSH and GPG Keys → New SSH key
- **GitLab**: Preferences → SSH Keys → Add new key

---

## 6. Kiểm tra kết nối

```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```

> Kết quả thành công sẽ hiển thị thông báo chào mừng từ GitHub/GitLab.

---

## 7. Clone Repository bằng SSH

```bash
# GitHub
git clone git@github.com:username/repo.git

# GitLab
git clone git@gitlab.com:username/repo.git
```

---

## ✅ Tổng hợp lệnh thường dùng

| Lệnh                                | Mục đích                          |
|-------------------------------------|-----------------------------------|
| `ssh-keygen -t ed25519 -f ~/.ssh/x` | Tạo SSH key mới                   |
| `ssh-add ~/.ssh/x`                  | Thêm key vào ssh-agent            |
| `cat ~/.ssh/x.pub`                  | Lấy public key                    |
| `ssh -T git@github.com/gitlab.com`  | Kiểm tra kết nối SSH              |
| `nano ~/.ssh/config`                | Cấu hình key cho từng domain      |
