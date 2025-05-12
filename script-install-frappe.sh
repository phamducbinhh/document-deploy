#!/bin/bash

# install-frappe.sh - Script to install Frappe framework with latest Node.js using NVM
# This script automates the installation of Frappe with all required dependencies

set -e
echo "==============================================="
echo "Frappe Framework Installation Script"
echo "This script will install Frappe with NVM and latest Node.js"
echo "==============================================="

# Function to check if command succeeded
check_command() {
    if [ $? -eq 0 ]; then
        echo "[✓] $1 completed successfully"
    else
        echo "[✗] $1 failed"
        exit 1
    fi
}

# Update package lists
echo "Updating package lists..."
sudo apt-get update
check_command "Package list update"

# STEP 1: Install git
echo "STEP 1: Installing git..."
sudo apt-get install -y git
check_command "Git installation"

# STEP 2: Install python-dev
echo "STEP 2: Installing python3-dev..."
sudo apt-get install -y python3-dev
check_command "Python3-dev installation"

# STEP 3: Install setuptools and pip
echo "STEP 3: Installing Python setuptools and pip..."
sudo apt-get install -y python3-setuptools python3-pip
check_command "Python setuptools and pip installation"

# STEP 4: Install virtualenv
echo "STEP 4: Installing virtualenv..."
sudo apt-get install -y python3.12-venv
check_command "Virtualenv installation"

# STEP 5: Install MariaDB
echo "STEP 5: Installing MariaDB..."
sudo apt-get install -y software-properties-common
sudo apt-get install -y mariadb-server
check_command "MariaDB installation"

# Check MariaDB status
echo "Checking MariaDB status..."
sudo systemctl status mariadb
echo "Setting up MariaDB security settings..."
echo "NOTE: You will be prompted to set the root password and other security settings"
sudo mysql_secure_installation

# STEP 6: Install MySQL database development files
echo "STEP 6: Installing MySQL database development files..."
sudo apt-get install -y libmysqlclient-dev
check_command "MySQL development files installation"

# STEP 7: Configure MariaDB for Unicode character encoding
echo "STEP 7: Configuring MariaDB for Unicode support..."
sudo bash -c 'cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOL
[server]
user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysqld.sock
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc-messages-dir = /usr/share/mysql
bind-address = 127.0.0.1
query_cache_size = 16M
log_error = /var/log/mysql/error.log

[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
EOL'
check_command "MariaDB configuration"

# Restart MariaDB to apply changes
echo "Restarting MariaDB..."
sudo service mysql restart
check_command "MariaDB restart"

# STEP 8: Install Redis
echo "STEP 8: Installing Redis server..."
sudo apt-get install -y redis-server
check_command "Redis server installation"

# STEP 9: Install Node.js using NVM
echo "STEP 9: Installing NVM and latest Node.js..."
sudo apt-get install -y curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
check_command "NVM installation"

# Load NVM without restarting terminal
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install latest Node.js version
echo "Installing latest Node.js version..."
nvm install node  # This installs the latest version
check_command "Node.js installation"

# STEP 10: Install Yarn
echo "STEP 10: Installing Yarn package manager..."
sudo apt-get install -y npm
sudo npm install -g yarn
check_command "Yarn installation"

# STEP 11: Install wkhtmltopdf
echo "STEP 11: Installing wkhtmltopdf for PDF generation..."
sudo apt-get install -y xvfb libfontconfig wkhtmltopdf
check_command "wkhtmltopdf installation"

# STEP 12: Install frappe-bench
echo "STEP 12: Installing frappe-bench..."
sudo -H pip3 install frappe-bench --break-system-packages
check_command "Frappe-bench installation"

# Verify bench installation
bench --version
check_command "Bench version check"

# STEP 13: Initialize frappe bench & install frappe
echo "STEP 13: Initializing frappe bench with version-15..."
bench init frappe-bench --frappe-branch version-15
check_command "Frappe bench initialization"

# STEP 14 install ERPNext latest version in bench & frappe
echo "STEP 14: Installing ERPNext..."
bench get-app erpnext --branch version-15
check_command "ERPNext installation"

# STEP 15 install hrms latest version in bench & frappe
echo "STEP 15: Installing hrms..."
bench get-app hrms --branch version-15
check_command "hrms installation"

# STEP 16 install raven latest version in bench & frappe
echo "STEP 16: Installing raven..."
bench get-app https://github.com/The-Commit-Company/raven
bench install-app raven
check_command "raven installation"

# STEP 17: Create a new site with React.js
echo "STEP 17: Creating a new site with React.js..."
echo "bench new-site react.test"
echo "bench --site react.test add-to-hosts"
echo "bench set-config -g developer_mode 1"
echo "bench --site react.test set-config ignore_csrf 1"
echo "bench use react.test"
check_command "Site creation"
echo "==============================================="
echo "Frappe installation completed successfully!"
