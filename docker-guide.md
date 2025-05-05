
## Cài Đặt Docker và Docker Compose Trên Ubuntu

### Bước 1: Cập nhật hệ thống
```bash
sudo apt update
sudo apt upgrade -y
```

### Bước 2: Gỡ phiên bản Docker cũ (nếu có)
```bash
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /etc/apt/keyrings/docker.asc
```

### Bước 3: Cài Docker Engine
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Bước 4: Cài Docker Packages.
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Bước 5: Cho phép chạy Docker không cần sudo
```bash
sudo usermod -aG docker $USER
newgrp docker
```
### Bước 6: Kiểm tra Docker
```bash
sudo docker version
sudo docker run hello-world
```

# Hướng Dẫn Docker: Lệnh Cơ Bản và Triển Khai Ứng Dụng

Tài liệu này cung cấp hướng dẫn toàn diện về các lệnh Docker cơ bản và cách triển khai ứng dụng với Docker.

## Mục Lục
- [Các Lệnh Docker Cơ Bản](#các-lệnh-docker-cơ-bản)
- [Các Lệnh Docker Compose](#các-lệnh-docker-compose)
- [Triển Khai Ứng Dụng Next.js với Docker](#triển-khai-ứng-dụng-nextjs-với-docker)
- [Các Thực Hành Tốt Nhất](#các-thực-hành-tốt-nhất)
- [Khắc Phục Sự Cố](#khắc-phục-sự-cố)

## Các Lệnh Docker Cơ Bản

### Quản Lý Image
```bash
docker images
docker rmi <ten_image_hoac_id>
docker image prune
docker image prune -a
docker build -t <ten_image>:<tag> <duong_dan_den_thu_muc>
docker pull <ten_image>:<tag>
docker push <ten_image>:<tag>
```

### Quản Lý Container
```bash
docker ps
docker ps -a
docker start <id_hoac_ten_container>
docker stop <id_hoac_ten_container>
docker rm <id_hoac_ten_container>
docker container prune
docker run -d -p <cong_host>:<cong_container> --name <ten_container> <ten_image>:<tag>
docker exec -it <id_hoac_ten_container> <lenh>
docker logs <id_hoac_ten_container>
docker logs -f <id_hoac_ten_container>
```

### Quản Lý Hệ Thống
```bash
docker info
docker system df
docker system prune
docker system prune -a --volumes
```

## Các Lệnh Docker Compose
```bash
docker compose up
docker compose up -d
docker compose down
docker compose down -v
docker compose build
docker compose logs
docker compose logs -f
docker compose ps
docker compose exec <ten_service> <lenh>
```

## Triển Khai Ứng Dụng Next.js với Docker

### Cấu Trúc Dự Án
```
my-nextjs-app/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── next.config.js
├── package.json
├── public/
└── src/
```

### Dockerfile cho Next.js
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```

### docker-compose.yml
```yaml
services:
  nextjs:
    container_name: nextjs-app
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    restart: always
    environment:
      - NODE_ENV=production
    volumes:
      - ./public:/app/public
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### Cấu Hình Next.js
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
}

module.exports = nextConfig
```

### Các Bước Triển Khai
1. Chuẩn bị ứng dụng
2. Build và chạy ứng dụng
```bash
docker-compose build
docker-compose up -d
```
3. Kiểm tra
```bash
docker-compose ps
docker-compose logs -f
```
4. Truy cập http://localhost:3000

## Các Thực Hành Tốt Nhất
- Dùng Multi-Stage Build
- Tối ưu Dockerfile
- Sử dụng .dockerignore
- Chỉ rõ phiên bản
- Không chạy với root
- Dùng biến môi trường
- Thêm healthcheck
- Gắn volume
- Orchestration cho production
- Tích hợp CI/CD

## Khắc Phục Sự Cố
1. Container thoát sớm → `docker logs`
2. Xung đột cổng → `lsof -i :<port>`
3. Lỗi quyền → kiểm tra user trong Dockerfile
4. Lỗi mạng → `docker network ls`
5. Thiếu tài nguyên → `docker stats`
6. Lỗi build → xem lại Dockerfile
7. Lỗi volume → kiểm tra cấu hình volume
