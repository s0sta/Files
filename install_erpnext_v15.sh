#!/bin/bash

###############################################################################
# ERPNext v15 Automated Installation Script for Ubuntu 22.04 LTS
# 
# This script automates the complete installation of ERPNext v15
# Based on the official guide from discuss.frappe.io
#
# Usage: sudo bash install_erpnext_v15.sh
###############################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
LOG_FILE="/var/log/erpnext_install_$(date +%d-%m-%Y_%H-%M-%S).log"

# Function to print colored output
print_step() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
    echo "Error: $1" >> "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "Success: $1" >> "$LOG_FILE"
}

# Function to run command and log it
run_command() {
    echo "Running: $1" >> "$LOG_FILE"
    eval "$1" 2>&1 | tee -a "$LOG_FILE" || return 1
    return 0
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root. Use: sudo bash install_erpnext_v15.sh"
    exit 1
fi

# Start installation
clear
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ERPNext v15 Installation Script for Ubuntu 22.04 LTS    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Log file: $LOG_FILE"
echo ""

# Get user input
read -p "Enter Frappe username (default: frappe): " FRAPPE_USER
FRAPPE_USER=${FRAPPE_USER:-frappe}

read -p "Enter MySQL root password: " MYSQL_ROOT_PASSWORD

read -p "Enter timezone (default: Asia/Riyadh): " TIMEZONE
TIMEZONE=${TIMEZONE:-Asia/Riyadh}

read -p "Enter site name (default: site1.local): " SITE_NAME
SITE_NAME=${SITE_NAME:-site1.local}

echo ""
echo "Configuration Summary:"
echo "  Frappe User: $FRAPPE_USER"
echo "  Timezone: $TIMEZONE"
echo "  Site Name: $SITE_NAME"
echo ""

read -p "Continue with installation? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

###############################################################################
# STEP 1: Server Setup
###############################################################################
print_step "STEP 1: Server Setup"

# Check if user already exists
if id "$FRAPPE_USER" &>/dev/null; then
    print_success "User $FRAPPE_USER already exists"
else
    print_step "Creating new user: $FRAPPE_USER"
    run_command "useradd -m -s /bin/bash $FRAPPE_USER" || true
    run_command "usermod -aG sudo $FRAPPE_USER"
    print_success "User $FRAPPE_USER created"
fi

# Set timezone
print_step "Setting timezone to $TIMEZONE"
run_command "timedatectl set-timezone \"$TIMEZONE\""
print_success "Timezone set to $TIMEZONE"

# Update system packages
print_step "Updating system packages (this may take a while)..."
run_command "apt-get update -y"
run_command "apt-get upgrade -y"
print_success "System packages updated"

###############################################################################
# STEP 2: Install Required Packages
###############################################################################
print_step "STEP 2: Installing Required Packages"

# Install GIT
print_step "Installing GIT..."
run_command "apt-get install -y git"
print_success "GIT installed"

# Install Python and dependencies
print_step "Installing Python 3.10 and dependencies..."
run_command "apt-get install -y python3-dev python3.10-dev python3-setuptools python3-pip python3-distutils python3.10-venv"
print_success "Python installed"

# Install Python Virtual Environment
run_command "apt-get install -y python3.10-venv"
print_success "Python Virtual Environment installed"

# Install Software Properties Common
run_command "apt-get install -y software-properties-common"
print_success "Software Properties Common installed"

# Install MariaDB
print_step "Installing MariaDB..."
export DEBIAN_FRONTEND=noninteractive
run_command "apt-get install -y mariadb-server mariadb-client"
print_success "MariaDB installed"

# Install Redis
print_step "Installing Redis..."
run_command "apt-get install -y redis-server"
print_success "Redis installed"

# Install other necessary packages
print_step "Installing fonts and PDF support..."
run_command "apt-get install -y xvfb libfontconfig wkhtmltopdf libmysqlclient-dev"
print_success "Fonts and PDF support installed"

###############################################################################
# STEP 3: Configure MySQL Server
###############################################################################
print_step "STEP 3: Configuring MySQL Server"

# Restart MySQL to ensure it's running
run_command "service mysql restart"
print_success "MySQL service restarted"

# Configure MySQL with secure installation
print_step "Securing MySQL installation..."
mysql -u root << MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

print_success "MySQL secured"

# Edit MySQL configuration
print_step "Configuring MySQL character set..."
cat >> /etc/mysql/my.cnf << 'MYSQL_CONFIG'

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
MYSQL_CONFIG

run_command "service mysql restart"
print_success "MySQL configured"

###############################################################################
# STEP 4: Install CURL, Node, NPM, and Yarn
###############################################################################
print_step "STEP 4: Installing CURL, Node, NPM, and Yarn"

# Install CURL
run_command "apt-get install -y curl"
print_success "CURL installed"

# Install NVM and Node 18
print_step "Installing Node.js 18..."
sudo -u $FRAPPE_USER bash << 'NODE_INSTALL'
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 18
NODE_INSTALL

print_success "Node.js 18 installed"

# Install NPM
run_command "apt-get install -y npm"
print_success "NPM installed"

# Install Yarn
run_command "npm install -g yarn"
print_success "Yarn installed"

###############################################################################
# STEP 5: Install Frappe Bench
###############################################################################
print_step "STEP 5: Installing Frappe Bench"

# Install Frappe Bench using pip
run_command "pip3 install frappe-bench"
print_success "Frappe Bench installed"

# Change to frappe user and initialize bench
print_step "Initializing Frappe Bench (this may take several minutes)..."
sudo -u $FRAPPE_USER bash << BENCH_INIT
    cd /home/$FRAPPE_USER
    bench init --frappe-branch version-15 frappe-bench
BENCH_INIT

print_success "Frappe Bench initialized"

# Change permissions
print_step "Setting directory permissions..."
run_command "chmod -R o+rx /home/$FRAPPE_USER/"
print_success "Directory permissions set"

# Create new site
print_step "Creating new site: $SITE_NAME"
sudo -u $FRAPPE_USER bash << SITE_CREATE
    cd /home/$FRAPPE_USER/frappe-bench
    bench new-site $SITE_NAME
SITE_CREATE

print_success "Site $SITE_NAME created"

###############################################################################
# STEP 6: Install ERPNext and Other Apps
###############################################################################
print_step "STEP 6: Installing ERPNext and Apps"

# Download apps
print_step "Downloading Payments app..."
sudo -u $FRAPPE_USER bash << GET_APPS
    cd /home/$FRAPPE_USER/frappe-bench
    bench get-app payments
GET_APPS

print_success "Payments app downloaded"

print_step "Downloading ERPNext v15..."
sudo -u $FRAPPE_USER bash << GET_ERPNEXT
    cd /home/$FRAPPE_USER/frappe-bench
    bench get-app --branch version-15 erpnext
GET_ERPNEXT

print_success "ERPNext v15 downloaded"

# Optional: Download HRMS
print_step "Downloading HRMS (HR Management System)..."
sudo -u $FRAPPE_USER bash << GET_HRMS
    cd /home/$FRAPPE_USER/frappe-bench
    bench get-app hrms
GET_HRMS

print_success "HRMS downloaded"

# Install apps
print_step "Installing ERPNext on site $SITE_NAME..."
sudo -u $FRAPPE_USER bash << INSTALL_APPS
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME install-app erpnext
INSTALL_APPS

print_success "ERPNext installed"

print_step "Installing HRMS on site $SITE_NAME..."
sudo -u $FRAPPE_USER bash << INSTALL_HRMS
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME install-app hrms
INSTALL_HRMS

print_success "HRMS installed"

###############################################################################
# STEP 7: Setup Production Server
###############################################################################
print_step "STEP 7: Setting Up Production Server"

# Enable scheduler
print_step "Enabling scheduler..."
sudo -u $FRAPPE_USER bash << ENABLE_SCHEDULER
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME enable-scheduler
ENABLE_SCHEDULER

print_success "Scheduler enabled"

# Disable maintenance mode
print_step "Disabling maintenance mode..."
sudo -u $FRAPPE_USER bash << DISABLE_MAINTENANCE
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME set-maintenance-mode off
DISABLE_MAINTENANCE

print_success "Maintenance mode disabled"

# Setup production config
print_step "Setting up production configuration..."
cd /home/$FRAPPE_USER/frappe-bench
run_command "bench setup production $FRAPPE_USER"
print_success "Production configuration set"

# Setup NGINX
print_step "Setting up NGINX web server..."
sudo -u $FRAPPE_USER bash << SETUP_NGINX
    cd /home/$FRAPPE_USER/frappe-bench
    bench setup nginx
SETUP_NGINX

print_success "NGINX configured"

# Final supervisor setup
print_step "Setting up Supervisor and finalizing..."
cd /home/$FRAPPE_USER/frappe-bench
run_command "supervisorctl restart all" || true
run_command "bench setup production $FRAPPE_USER" || true
print_success "Supervisor configured"

# Enable UFW firewall
print_step "Configuring firewall..."
run_command "ufw allow 22,25,143,80,443,3306,3022,8000/tcp"
run_command "ufw enable" || true
print_success "Firewall configured"

###############################################################################
# Installation Complete
###############################################################################
clear
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                ✅ INSTALLATION COMPLETED ✅                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📋 Installation Summary:${NC}"
echo "  ✓ Server Setup"
echo "  ✓ Required Packages Installed"
echo "  ✓ MySQL Server Configured"
echo "  ✓ Node.js, NPM, Yarn Installed"
echo "  ✓ Frappe Bench Initialized"
echo "  ✓ ERPNext v15 Installed"
echo "  ✓ HRMS Module Installed"
echo "  ✓ Production Server Configured"
echo ""
echo -e "${BLUE}🚀 Access Information:${NC}"
echo "  URL: http://$(hostname -I | awk '{print $1}'):80"
echo "  OR"
echo "  URL: http://localhost:80"
echo ""
echo -e "${BLUE}👤 Default Credentials:${NC}"
echo "  Username: Administrator"
echo "  Password: admin"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
echo "  1. Change the admin password immediately after first login!"
echo "  2. Log file saved at: $LOG_FILE"
echo "  3. To access the bench directory:"
echo "     cd /home/$FRAPPE_USER/frappe-bench"
echo "  4. To start development server:"
echo "     bench start"
echo "  5. To check status:"
echo "     bench status"
echo ""
echo -e "${BLUE}📝 Next Steps:${NC}"
echo "  1. Log in to ERPNext with admin credentials"
echo "  2. Set up your company and basic configuration"
echo "  3. For SSL certificate, run after 24hrs:"
echo "     sudo certbot --nginx"
echo ""
echo -e "${GREEN}✨ Happy ERPing! ✨${NC}"
echo ""
