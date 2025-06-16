#!/bin/bash

# Script tạo và cấu hình SSH key cho GitHub, GitLab và gitlab.oeg.vn

EMAIL="phamducbinh1712000@gmail.com"
SSH_DIR="$HOME/.ssh"
CONFIG_FILE="$SSH_DIR/config"
GITHUB_KEY="$SSH_DIR/github"
GITLAB_KEY="$SSH_DIR/gitlab"

# Màu cho thông báo
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}🔐 Đang tạo thư mục ~/.ssh (nếu chưa có)...${NC}"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
ls -la "$SSH_DIR"

# Tạo SSH key cho GitHub
echo -e "${GREEN}📁 Tạo SSH key cho GitHub...${NC}"
ssh-keygen -t ed25519 -C "$EMAIL" -f "$GITHUB_KEY" -N ""

# Tạo SSH key cho GitLab
echo -e "${GREEN}📁 Tạo SSH key cho GitLab...${NC}"
ssh-keygen -t ed25519 -C "$EMAIL" -f "$GITLAB_KEY" -N ""

# Khởi động ssh-agent và thêm key
echo -e "${GREEN}🚀 Thêm SSH key vào ssh-agent...${NC}"
eval "$(ssh-agent -s)"
ssh-add "$GITHUB_KEY"
ssh-add "$GITLAB_KEY"

# Tạo hoặc chỉnh sửa file cấu hình SSH
echo -e "${GREEN}⚙️ Cấu hình file ~/.ssh/config...${NC}"
touch "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile $GITHUB_KEY
  IdentitiesOnly yes

# GitLab
Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile $GITLAB_KEY
  IdentitiesOnly yes

# Hiển thị public key để copy lên GitHub/GitLab/gitlab.oeg.vn
echo -e "${GREEN}📋 Public key GitHub:${NC}"
cat "$GITHUB_KEY.pub"

echo -e "${GREEN}📋 Public key GitLab:${NC}"
cat "$GITLAB_KEY.pub"

# Kiểm tra kết nối
echo -e "${GREEN}✅ Kiểm tra kết nối SSH GitHub:${NC}"
ssh -T git@github.com || echo "👉 Hãy thêm public key vào GitHub trước."

echo -e "${GREEN}✅ Kiểm tra kết nối SSH GitLab:${NC}"
ssh -T git@gitlab.com || echo "👉 Hãy thêm public key vào GitLab trước."

echo -e "${GREEN}🎉 Hoàn tất! Hãy dán các public key vào GitHub, GitLab và gitlab.oeg.vn để hoàn tất quá trình kết nối.${NC}"
