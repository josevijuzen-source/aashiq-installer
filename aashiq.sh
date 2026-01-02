#!/bin/bash

while true; do
  clear
  echo "==============================="
  echo "        AASHIQ INSTALLER"
  echo "==============================="
  echo
  echo "[1] Install Panel (Direct)"
  echo "[2] Install Wings (Direct)"
  echo "[3] Uninstall Panel / Wings"
  echo "[0] Exit"
  echo
  read -p "Enter your choice: " choice
  echo

  case "$choice" in
    1)
      echo "Starting panel installation..."
      curl -fsSL https://raw.githubusercontent.com/josevijuzen-source/aashiq-installer/main/install-panel.sh | bash
      read -p "Press ENTER to return to menu..."
      ;;
    2)
      echo "Starting wings installation..."
      curl -fsSL https://raw.githubusercontent.com/josevijuzen-source/aashiq-installer/main/install-wings.sh | bash
      read -p "Press ENTER to return to menu..."
      ;;
    3)
      echo "Uninstalling..."
      curl -fsSL https://raw.githubusercontent.com/josevijuzen-source/aashiq-installer/main/uninstall.sh | bash
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
