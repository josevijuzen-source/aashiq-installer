#!/bin/bash
set -e

# Ensure deps
apt update -y >/dev/null 2>&1 || true
apt install -y curl expect >/dev/null 2>&1 || true

banner() {
  clear
  echo "======================================"
  echo "        AASHIQ INSTALLER"
  echo "======================================"
  echo
}

panel_install() {
  banner
  echo "[ PANEL INSTALLATION ]"
  echo

  # Hide 0–6 menu, then allow official questions
  expect << 'EOF'
spawn bash <(curl -fsSL https://pterodactyl-installer.se)
expect "Input 0-6:"
send "0\r"
interact
EOF
}

wings_install() {
  banner
  echo "[ WINGS INSTALLATION ]"
  echo

  read -p "Enter Panel URL (https://panel.example.com): " PANEL_URL
  read -p "Enter Node UUID: " NODE_UUID
  read -p "Enter Node Token: " NODE_TOKEN

  expect << EOF
spawn bash <(curl -fsSL https://pterodactyl-installer.se)

# Select Wings
expect "Input 0-6:"
send "1\r"

# Auto-configure
expect "Do you want to auto-configure Wings now?"
send "y\r"

# Fill details ONCE
expect "Enter UUID:"
send "$NODE_UUID\r"

expect "Enter Token:"
send "$NODE_TOKEN\r"

expect "Enter Panel URL"
send "$PANEL_URL\r"

interact
EOF
}

uninstall_all() {
  banner
  echo "[ UNINSTALL PANEL / WINGS ]"
  echo

  expect << 'EOF'
spawn bash <(curl -fsSL https://pterodactyl-installer.se)
expect "Input 0-6:"
send "6\r"
interact
EOF
}

while true; do
  banner
  echo "1) Panel"
  echo "2) Wings"
  echo "3) Uninstall"
  echo "0) Exit"
  echo
  read -p "Enter your choice: " choice

  case "$choice" in
    1) panel_install ;;
    2) wings_install ;;
    3) uninstall_all ;;
    0) exit ;;
    *) echo "Invalid choice"; sleep 1 ;;
  esac
done
