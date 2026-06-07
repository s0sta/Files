#!/bin/bash

###############################################################################
# ERPNext v15 - Non-Interactive Installation (Fully Automated)
# 
# This script installs ERPNext v15 with default values - no prompts!
# All configuration can be edited in the variables below.
#
# Usage: sudo bash install_erpnext_v15_auto.sh
###############################################################################

# ===== CONFIGURATION =====
FRAPPE_USER="frappe"           # Username for Frappe/ERPNext
MYSQL_ROOT_PASSWORD="Pass@123" # MySQL root password (CHANGE THIS!)
TIMEZONE="Asia/Riyadh"         # Server timezone
SITE_NAME="site1.local"        # Site name
# =========================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG_FILE="/var/log/erpnext_auto_install_$(date +%d-%m-%Y_%H-%M-%S).log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

print_step() {
    echo -e "\n${BLUE}>>> $1${NC}"
    log "STEP: $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    log "SUCCESS: $1"
}

print_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    log "ERROR: $1"
}

# Check root
if [[ $EUID -ne 0 ]]; then
    print_error "Must be root. Use: sudo bash install_erpnext_v15_auto.sh"
    exit 1
fi

# Start
clear
echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  ERPNext v15 - Fully Automated Installation Script    ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Configuration:"
echo "  User: $FRAPPE_USER"
echo "  Timezone: $TIMEZONE"
echo "  Site: $SITE_NAME"
echo "  Log: $LOG_FILE"
echo ""

###############################################################################
# STEP 1: Server Setup
###############################################################################
print_step "Server Setup"

# Create user if not exists
if ! id "$FRAPPE_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$FRAPPE_USER"
    usermod -aG sudo "$FRAPPE_USER"
    print_success "User $FRAPPE_USER created"
else
    print_success "User $FRAPPE_USER exists"
fi

# Set timezone
timedatectl set-timezone "$TIMEZONE"
print_success "Timezone set to $TIMEZONE"

# Update system
print_step "Updating system packages..."
apt-get update -y >> "$LOG_FILE" 2>&1
apt-get upgrade -y >> "$LOG_FILE" 2>&1
print_success "System updated"

###############################################################################
# STEP 2: Install Packages
###############################################################################
print_step "Installing required packages"

packages=(
    "git"
    "python3-dev"
    "python3.10-dev"
    "python3-setuptools"
    "python3-pip"
    "python3-distutils"
    "python3.10-venv"
    "software-properties-common"
    "mariadb-server"
    "mariadb-client"
    "redis-server"
    "xvfb"
    "libfontconfig"
    "wkhtmltopdf"
    "libmysqlclient-dev"
    "curl"
    "npm"
)

for package in "${packages[@]}"; do
    apt-get install -y "$package" >> "$LOG_FILE" 2>&1
done

print_success "All packages installed"

###############################################################################
# STEP 3: Configure MySQL
###############################################################################
print_step "Configuring MySQL"

service mysql restart >> "$LOG_FILE" 2>&1

mysql -u root << MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cat >> /etc/mysql/my.cnf << 'MYSQL_CONFIG'

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
MYSQL_CONFIG

service mysql restart >> "$LOG_FILE" 2>&1
print_success "MySQL configured"

###############################################################################
# STEP 4: Install Node.js
###############################################################################
print_step "Installing Node.js 18"

sudo -u "$FRAPPE_USER" bash << 'NODE_INSTALL'
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    source ~/.profile
    nvm install 18
NODE_INSTALL

npm install -g yarn >> "$LOG_FILE" 2>&1
print_success "Node.js and Yarn installed"

###############################################################################
# STEP 5: Install Frappe Bench
###############################################################################
print_step "Installing Frappe Bench"

pip3 install frappe-bench >> "$LOG_FILE" 2>&1

sudo -u "$FRAPPE_USER" bash << BENCH_INIT
    cd /home/$FRAPPE_USER
    bench init --frappe-branch version-15 frappe-bench
BENCH_INIT

chmod -R o+rx /home/$FRAPPE_USER/

print_success "Frappe Bench installed"

###############################################################################
# STEP 6: Create Site
###############################################################################
print_step "Creating site: $SITE_NAME"

sudo -u "$FRAPPE_USER" bash << SITE_CREATE
    cd /home/$FRAPPE_USER/frappe-bench
    bench new-site $SITE_NAME
SITE_CREATE

print_success "Site created"

###############################################################################
# STEP 7: Install Apps
###############################################################################
print_step "Installing ERPNext apps"

sudo -u "$FRAPPE_USER" bash << GET_APPS
    cd /home/$FRAPPE_USER/frappe-bench
    bench get-app payments
    bench get-app --branch version-15 erpnext
    bench get-app hrms
GET_APPS

print_success "Apps downloaded"

print_step "Installing apps on site"

sudo -u "$FRAPPE_USER" bash << INSTALL_APPS
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME install-app erpnext
    bench --site $SITE_NAME install-app hrms
INSTALL_APPS

print_success "Apps installed"

###############################################################################
# STEP 8: Production Setup
###############################################################################
print_step "Setting up production"

sudo -u "$FRAPPE_USER" bash << PROD_SETUP
    cd /home/$FRAPPE_USER/frappe-bench
    bench --site $SITE_NAME enable-scheduler
    bench --site $SITE_NAME set-maintenance-mode off
PROD_SETUP

cd /home/$FRAPPE_USER/frappe-bench
bench setup production "$FRAPPE_USER" >> "$LOG_FILE" 2>&1

sudo -u "$FRAPPE_USER" bash << NGINX_SETUP
    cd /home/$FRAPPE_USER/frappe-bench
    bench setup nginx
NGINX_SETUP

supervisorctl restart all >> "$LOG_FILE" 2>&1 || true
bench setup production "$FRAPPE_USER" >> "$LOG_FILE" 2>&1 || true

# Firewall
ufw allow 22,25,143,80,443,3306,3022,8000/tcp >> "$LOG_FILE" 2>&1 || true
ufw enable >> "$LOG_FILE" 2>&1 || true

print_success "Production setup complete"

###############################################################################
# Completion
###############################################################################
clear
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        ✅ INSTALLATION COMPLETED SUCCESSFULLY! ✅    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}🎯 Access ERPNext:${NC}"
echo "   URL: http://$(hostname -I | awk '{print $1}'):80"
echo "   User: Administrator"
echo "   Password: admin"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT - CHANGE PASSWORD NOW!${NC}"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo "   cd /home/$FRAPPE_USER/frappe-bench"
echo "   bench start              # Development server"
echo "   bench status             # Check status"
echo "   bench restart            # Restart services"
echo "   bench backup             # Backup database"
echo ""
echo -e "${BLUE}Log file: $LOG_FILE${NC}"
echo ""
echo "✨ Happy ERPing! ✨"
echo ""
