#!/bin/bash
set -e

echo "Installing AASHIQ INSTALLER..."

curl -fsSL https://raw.githubusercontent.com/josevijuzen-source/aashiq-installer/main/aashiq.sh \
  -o /usr/local/bin/aashiq

chmod +x /usr/local/bin/aashiq

echo ""
echo "✅ AASHIQ INSTALLER INSTALLED"
echo "👉 Run command: aashiq"
