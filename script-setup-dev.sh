#!/bin/bash

# Ubuntu 24.04 - Development Environment Setup Script
# Installs: NVM, Node.js, npm, yarn, pnpm, Git, and Nginx

# Print colored output
print_message() {
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}$1${NC}"
}

# Error handling
set -e
trap 'echo "❌ Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

print_message "🚀 Starting development environment setup..."

# Update system packages
print_message "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install build essentials and dependencies
print_message "🔧 Installing build essentials and dependencies..."
sudo apt install -y build-essential curl wget ca-certificates gnupg

# Install Git
print_message "🔧 Installing Git..."
sudo apt install -y git
git --version

# Install Nginx
print_message "🌐 Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
nginx -v

# Install NVM
print_message "📥 Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install Node.js LTS
print_message "📦 Installing Node.js LTS..."
nvm install --lts
nvm use --lts
node -v
npm -v

# Ensure global npm bin is in PATH during script execution
export PATH="$PATH:$(npm bin -g)"

# Install Yarn
print_message "📥 Installing Yarn..."
npm install -g yarn
yarn --version

# Install pnpm
print_message "📥 Installing pnpm..."
npm install -g pnpm
pnpm --version

# Add NVM and npm global path to shell profile if not already present
if ! grep -q "NVM_DIR" ~/.bashrc; then
    print_message "🛠️ Adding NVM to ~/.bashrc..."
    cat << 'EOF' >> ~/.bashrc

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
fi

if ! grep -q "npm bin -g" ~/.bashrc; then
    print_message "🛠️ Adding npm global bin to PATH in ~/.bashrc..."
    cat << 'EOF' >> ~/.bashrc

# Add npm global bin to PATH
export PATH="$PATH:$(npm bin -g)"
EOF
fi

print_message "✅ Setup complete! Development environment is ready."
print_message "📋 Installed versions:"
echo "--------------------------------"
echo "Git: $(git --version | cut -d ' ' -f 3)"
echo "Nginx: $(nginx -v 2>&1 | cut -d '/' -f 2)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Yarn: $(yarn -v)"
echo "pnpm: $(pnpm -v)"
echo "--------------------------------"
echo "👉 You may need to run 'source ~/.bashrc' or restart your terminal to apply environment variables."
