#!/bin/bash
set -e

clear
echo "=================================="
echo "      AASHIQ PANEL INSTALLER"
echo "=================================="
echo ""

# ---------------- DOMAIN ----------------
read -p "Enter your panel domain (example: panel.example.com): " FQDN
while [[ -z "$FQDN" ]]; do
  echo "Domain cannot be empty!"
  read -p "Enter your panel domain: " FQDN
done

# ---------------- ADMIN USER ----------------
echo ""
echo "Create Admin User"
echo "-----------------"

read -p "Admin Email: " ADMIN_EMAIL
read -p "Username: " ADMIN_USERNAME
read -p "First Name: " ADMIN_FIRSTNAME
read -p "Last Name: " ADMIN_LASTNAME

echo ""
read -s -p "Password: " ADMIN_PASSWORD
echo ""
read -s -p "Confirm Password: " ADMIN_PASSWORD_CONFIRM
echo ""

if [[ "$ADMIN_PASSWORD" != "$ADMIN_PASSWORD_CONFIRM" ]]; then
  echo "❌ Passwords do not match"
  exit 1
fi

# ---------------- CONFIRM ----------------
echo ""
echo "=================================="
echo " Panel Domain : $FQDN"
echo " Admin Email  : $ADMIN_EMAIL"
echo " Username     : $ADMIN_USERNAME"
echo "=================================="
read -p "Continue installation? (y/N): " CONFIRM

[[ ! "$CONFIRM" =~ ^[Yy]$ ]] && exit 0

# ---------------- INSTALL ----------------
export FQDN
export email="$ADMIN_EMAIL"
export user_email="$ADMIN_EMAIL"
export user_username="$ADMIN_USERNAME"
export user_firstname="$ADMIN_FIRSTNAME"
export user_lastname="$ADMIN_LASTNAME"
export user_password="$ADMIN_PASSWORD"

export ASSUME_SSL=true
export CONFIGURE_LETSENCRYPT=true
export CONFIGURE_FIREWALL=true

echo ""
echo "🚀 Starting Pterodactyl Panel Installation..."
echo ""

bash <(curl -fsSL https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/install.sh) <<EOF
0
y
EOF

echo ""
echo "✅ PANEL INSTALLATION COMPLETED"
echo "🌐 Panel URL: https://$FQDN"
echo ""
echo "Press ENTER to return to menu..."
read
