#!/bin/bash

while true; do
  clear
  echo "================================="
  echo "        AASHIQ INSTALLER"
  echo "================================="
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
      echo "Install Panel selected"
      ;;
    2)
      echo "Install Wings selected"
      ;;
    3)
      echo "Uninstall selected"
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
