#!/bin/bash
set -e

echo "Installing AASHIQ Installer..."

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install aashiq command
curl -fsSL https://raw.githubusercontent.com/josevijuzen-source/aashiq-installer/main/aashiq.sh \
  -o /usr/local/bin/aashiq

chmod +x /usr/local/bin/aashiq

echo
echo "✅ AASHIQ Installer installed successfully!"
echo "➡ Run: aashiq"
