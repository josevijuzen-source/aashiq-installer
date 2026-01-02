#!/bin/bash

while true; do
  clear
  echo "==============================="
  echo "        AASHIQ INSTALLER"
  echo "==============================="
  echo
  echo "[1] Install Panel"
  echo "[2] Install Wings"
  echo "[3] Uninstall Panel / Wings"
  echo "[0] Exit"
  echo
  read -p "Enter your choice: " choice
  echo

  case "$choice" in
    1)
      echo "Starting Panel Installer..."
      bash <(curl -fsSL https://pterodactyl-installer.se) panel
      read -p "Press ENTER to return to menu..."
      ;;
    2)
      echo "Starting Wings Installer..."
      bash <(curl -fsSL https://pterodactyl-installer.se) wings
      read -p "Press ENTER to return to menu..."
      ;;
    3)
      echo "Starting Uninstall..."
      bash <(curl -fsSL https://pterodactyl-installer.se) uninstall
      read -p "Press ENTER to return to menu..."
      ;;
    0)
      exit
      ;;
    *)
      echo "Invalid choice"
      sleep 2
      ;;
  esac
done
