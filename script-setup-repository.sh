#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display step information
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Function to display success messages
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to display warning messages
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to display error messages
error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to handle repository setup
setup_repo() {
    local repo_url=$1
    local dir_name=$2
    local package_manager=$3
    
    info "Setting up repository: $dir_name"
    
    # Clone repository if it doesn't exist
    if [ ! -d "$dir_name" ]; then
        info "Cloning $repo_url into $dir_name..."
        git clone "$repo_url" "$dir_name"
        if [ $? -ne 0 ]; then
            error "Failed to clone $repo_url"
            return 1
        fi
    else
        warning "Directory $dir_name already exists, skipping clone"
    fi
    
    # Change to repository directory
    cd "$dir_name" || { error "Failed to change directory to $dir_name"; return 1; }
    
    # Checkout dev branch
    info "Checking out dev branch..."
    git checkout dev
    if [ $? -ne 0 ]; then
        warning "Failed to checkout dev branch, it might not exist"
    fi
    
    # Install dependencies
    info "Installing dependencies using $package_manager..."
    if [ "$package_manager" == "npm" ]; then
        npm install
    elif [ "$package_manager" == "pnpm" ]; then
        # Check if pnpm is installed
        if ! command -v pnpm &> /dev/null; then
            warning "pnpm is not installed. Installing pnpm..."
            npm install -g pnpm
        fi
        pnpm install
    else
        error "Unsupported package manager: $package_manager"
        cd ..
        return 1
    fi
    
    # Copy .env.example to .env if it exists
    if [ -f ".env.example" ]; then
        info "Copying .env.example to .env..."
        cp .env.example .env
        if [ $? -ne 0 ]; then
            warning "Failed to copy .env.example to .env"
        fi
    else
        warning "No .env.example file found"
    fi
    
    # Return to parent directory
    cd ..
    
    success "Repository $dir_name setup completed"
    echo ""
}

# Main script execution
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   OEG Projects Setup Script         ${NC}"
echo -e "${GREEN}======================================${NC}"

# Create dev-workspaces directory if it doesn't exist
WORKSPACE_DIR=~/dev-workspaces
info "Creating workspace directory at $WORKSPACE_DIR if it doesn't exist"
mkdir -p "$WORKSPACE_DIR"

# Change to workspace directory
cd "$WORKSPACE_DIR" || { error "Failed to change directory to $WORKSPACE_DIR"; exit 1; }
success "Working in directory: $(pwd)"
echo ""

# Setup repositories
info "Starting repositories setup process..."
echo ""

# npm based repositories
setup_repo "git@gitlab.oeg.vn:oeg-tech/cyber/cyber-hub-client.git" "oeg-cyber-fe" "npm"
setup_repo "git@gitlab.oeg.vn:oeg-tech/game-portal/game-portal-frontend.git" "oeg-game-fe" "npm"
setup_repo "git@gitlab.oeg.vn:oeg-tech/landing-page/FE-PNNLT.git" "oeg-landing-001" "npm"
setup_repo "git@gitlab.oeg.vn:oeg-tech/landing-page/OG005.git" "oeg-landing-005" "npm"
setup_repo "git@gitlab.oeg.vn:oeg-tech/talent-house/talent-house-frontend.git" "oeg-talent-fe" "npm"
setup_repo "git@gitlab.oeg.vn:fus/fus-web-frontend.git" "oeg-fus-fe" "npm"

# pnpm based repositories
setup_repo "git@gitlab.com:oeg_tech/esports/frontendv2.git" "oeg-esporst-fe" "pnpm"
setup_repo "git@gitlab.com:oeg_tech/oeg.vn-v2.git" "oeg-home-fe" "pnpm"
setup_repo "git@gitlab.com:oeg_tech/news-project/news.oeg.vn.git" "oeg-space-fe" "pnpm"
setup_repo "git@gitlab.com:oeg_tech/profile.oeg.vn.git" "oeg-profile-fe" "pnpm"

echo -e "${GREEN}======================================${NC}"
success "All repositories have been set up in $WORKSPACE_DIR"
echo -e "${GREEN}======================================${NC}"
