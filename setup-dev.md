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
trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

print_message "Starting development environment setup..."

# Update system packages
print_message "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install build essentials and other dependencies
print_message "Installing build essentials and dependencies..."
sudo apt install -y build-essential curl wget ca-certificates gnupg

# Install Git
print_message "Installing Git..."
sudo apt install -y git
git --version

# Install Nginx
print_message "Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
nginx -v

# Install NVM (Node Version Manager)
print_message "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM immediately for the script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install Node.js LTS
print_message "Installing Node.js LTS..."
nvm install --lts
nvm use --lts
node --version
npm --version

# Install Yarn
print_message "Installing Yarn..."
npm install -g yarn
yarn --version

# Install pnpm
print_message "Installing pnpm..."
npm install -g pnpm
export PATH="$PATH:$(npm config get prefix)/bin"
pnpm --version || echo "pnpm installation may require a new terminal session"

# Add NVM to shell profile if not already there
if ! grep -q "NVM_DIR" ~/.bashrc; then
    print_message "Adding NVM to shell startup script..."
    cat << 'EOF' >> ~/.bashrc

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
fi

# Add npm global packages to PATH in .bashrc
if ! grep -q "npm-global" ~/.bashrc; then
    print_message "Adding npm global packages to PATH..."
    cat << 'EOF' >> ~/.bashrc

# npm global packages
export PATH="$PATH:$(npm config get prefix)/bin"
EOF
fi

print_message "Setup complete! Development environment is ready."
print_message "Installed versions:"
echo "--------------------------------"
echo "Git: $(git --version | cut -d ' ' -f 3)"
echo "Nginx: $(nginx -v 2>&1 | cut -d '/' -f 2)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "yarn: $(yarn -v)"
echo "pnpm: $(pnpm -v)"
echo "--------------------------------"
echo "You may need to restart your terminal or run 'source ~/.bashrc' to use NVM."
