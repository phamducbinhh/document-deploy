#!/bin/bash
# Frappe/ERPNext Version-15 Installation Script for Ubuntu 24.04 LTS
# This script automates the installation process of Frappe/ERPNext version 15 with Raven
# Based on the guide provided

# Check if script is run as root
if [ "$(id -u)" -eq 0 ]; then
  echo "Error: This script should not be run as root or with sudo."
  echo "Please run as a regular user. The script will use sudo when needed."
  exit 1
fi

# Exit on error
set -e

# Function to check if command succeeded
check_command() {
  if [ $? -ne 0 ]; then
    echo "Error: $1 failed. Please check the output above for details."
    exit 1
  fi
}

# Print header
echo "================================================"
echo "    Frappe/ERPNext Version-15 Setup Script      "
echo "    With Raven Communication App                "
echo "    For Ubuntu 24.04 LTS                        "
echo "================================================"

# Update system packages
echo -e "\n[1/19] Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Git
echo -e "\n[2/19] Installing Git..."
sudo apt-get install -y git

# Install Python development tools
echo -e "\n[3/19] Installing Python development tools..."
sudo apt-get install -y python3-dev

# Install setuptools and pip
echo -e "\n[4/19] Installing Python setuptools and pip..."
sudo apt-get install -y python3-setuptools python3-pip

# Install virtualenv
echo -e "\n[5/19] Installing Python virtualenv..."
sudo apt install -y python3.12-venv

# Install MariaDB
echo -e "\n[6/19] Installing MariaDB..."
sudo apt-get install -y software-properties-common
sudo apt install -y mariadb-server

# Configure MariaDB securely (this part will require user interaction)
echo -e "\n[7/19] Configuring MariaDB securely..."
echo "NOTE: You will need to answer the prompts during mysql_secure_installation:"
echo "  - Press ENTER for current password (none)"
echo "  - Type Y to switch to unix_socket authentication"
echo "  - Type Y to change the root password (and set it to something you'll remember for site creation)"
echo "  - Type Y to remove anonymous users"
echo "  - Type Y to disallow root login remotely"
echo "  - Type Y to remove test database"
echo "  - Type Y to reload privilege tables"
sudo mysql_secure_installation

# Install MySQL database development files
echo -e "\n[8/19] Installing MySQL development files..."
sudo apt-get install -y libmysqlclient-dev

# Configure MariaDB for UTF-8
echo -e "\n[9/19] Configuring MariaDB for UTF-8..."
sudo tee -a /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null << 'EOF'

[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci      
 
[mysql]
default-character-set = utf8mb4
EOF

# Restart MariaDB
echo -e "\n[10/19] Restarting MariaDB..."
sudo service mysql restart

# Install Redis
echo -e "\n[11/19] Installing Redis server..."
sudo apt-get install -y redis-server

# Install Node.js 18.x
echo -e "\n[12/19] Installing Node.js 18.x..."
sudo apt-get install -y curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 18

# Install Yarn
echo -e "\n[13/19] Installing Yarn..."
sudo apt-get install -y npm
sudo npm install -g yarn

# Install wkhtmltopdf
echo -e "\n[14/19] Installing wkhtmltopdf..."
sudo apt-get install -y xvfb libfontconfig wkhtmltopdf

# Install frappe-bench
echo -e "\n[15/19] Installing frappe-bench..."
sudo -H pip3 install frappe-bench --break-system-packages

# Validate installation
echo -e "\n[16/20] Validating bench installation..."
bench --version
check_command "Bench installation"

# Initialize frappe bench
echo -e "\n[17/20] Initializing frappe bench with version-15..."
bench init frappe-bench --frappe-branch version-15

cd frappe-bench/

# Create a new site
read -p "Enter your site name (e.g., mysite.local): " sitename
read -sp "Enter MariaDB root password: " mariadb_password
echo ""
read -sp "Enter site admin password (default: admin): " admin_password
admin_password=${admin_password:-admin}
echo -e "\n[18/20] Creating new site: $sitename..."
bench new-site "$sitename" --mariadb-root-password "$mariadb_password" --admin-password "$admin_password"
check_command "Site creation"
bench --site "$sitename" add-to-hosts

# Install Raven app
echo -e "\n[20/20] Installing Raven app..."
bench get-app --branch v2.0.3 https://github.com/The-Commit-Company/raven.git
bench --site "$sitename" install-app raven

echo -e "\n================================================"
echo "    Installation Complete!                        "
echo "================================================"
echo "You can now start the Frappe server with: bench start"
echo "Access your ERPNext site at: http://$sitename:8000"
echo "Login with:"
echo "  Username: Administrator"
echo "  Password: $admin_password (as specified during setup)"
echo "Raven has been installed for your communication needs"
echo "NOTE: For production use, additional setup is recommended."
echo "      See the Frappe documentation for production deployment."
echo "================================================"
