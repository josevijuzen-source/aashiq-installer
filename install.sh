#!/bin/bash

clear
echo "=================================="
echo "        AASHIQ INSTALLER"
echo "=================================="
echo
echo "[1] Install Panel"
echo "[2] Install Wings"
echo "[3] Uninstall Panel / Wings"
echo "[0] Exit"
echo

read -p "Enter your choice: " choice

case "$choice" in
  1)
    bash <(curl -fsSL https://raw.githubusercontent.com/josevijuzn-source/aashiq-installer/main/install-panel.sh)
    ;;
  2)
    bash <(curl -fsSL https://raw.githubusercontent.com/josevijuzn-source/aashiq-installer/main/installer-wings.sh)
    ;;
  3)
    echo "Uninstall coming soon"
    ;;
  0)
    exit 0
    ;;
  *)
    echo "Invalid option"
    ;;
esac
