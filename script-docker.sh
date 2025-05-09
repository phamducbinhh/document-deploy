#!/bin/bash

# Docker and Docker Compose Auto-Installation Script for Ubuntu
# Created: May 9, 2025

# Exit immediately if a command exits with a non-zero status
set -e

# Terminal colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}===== Docker Installation Script for Ubuntu =====${NC}"

# Step 1: Update the system
echo -e "\n${GREEN}Step 1: Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

# Step 2: Remove old Docker versions (if any)
echo -e "\n${GREEN}Step 2: Removing any old Docker installations...${NC}"
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras || true

# Clean up Docker directories and files
echo -e "\n${GREEN}Cleaning up Docker directories and files...${NC}"
sudo rm -rf /var/lib/docker || true
sudo rm -rf /var/lib/containerd || true
sudo rm -f /etc/apt/sources.list.d/docker.list || true
sudo rm -f /etc/apt/keyrings/docker.asc || true

# Step 3: Install prerequisites
echo -e "\n${GREEN}Step 3: Installing prerequisites...${NC}"
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Step 4: Add Docker's official GPG key
echo -e "\n${GREEN}Step 4: Adding Docker's GPG key...${NC}"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Step 5: Set up the Docker repository
echo -e "\n${GREEN}Step 5: Setting up Docker repository...${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt package index
sudo apt-get update

# Step 6: Install Docker Engine and tools
echo -e "\n${GREEN}Step 6: Installing Docker Engine and related tools...${NC}"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 7: Add current user to Docker group to run Docker without sudo
echo -e "\n${GREEN}Step 7: Adding current user to the docker group...${NC}"
sudo usermod -aG docker $USER
newgrp docker
echo -e "${YELLOW}Note: You may need to log out and log back in for the group changes to take effect.${NC}"

# Step 8: Enable and start Docker service
echo -e "\n${GREEN}Step 8: Enabling and starting Docker service...${NC}"
sudo systemctl enable docker
sudo systemctl start docker

# Step 9: Verify Docker installation
echo -e "\n${GREEN}Step 9: Verifying Docker installation...${NC}"
docker --version
docker compose version

echo -e "\n${GREEN}Testing Docker with hello-world image...${NC}"
sudo docker run hello-world

echo -e "\n${YELLOW}===== Docker installation complete! =====${NC}"
echo -e "${YELLOW}To run Docker without sudo in this session, run: ${NC}newgrp docker"
echo -e "${YELLOW}You may need to log out and log back in for group changes to take full effect.${NC}"