#!/bin/bash
set -e

clear
echo "==================================="
echo "     AASHIQ | WINGS INSTALLER"
echo "==================================="
echo

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

# OS check
if ! command -v curl >/dev/null; then
  apt update -y && apt install -y curl
fi

echo "▶ Installing required dependencies..."
apt update -y
apt install -y \
  curl tar unzip git \
  ca-certificates gnupg lsb-release \
  docker.io docker-compose

systemctl enable docker
systemctl start docker

echo "✅ Docker installed"

# Download Wings
echo
echo "▶ Downloading Wings..."
mkdir -p /etc/pterodactyl
cd /etc/pterodactyl

curl -L -o wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
chmod +x wings

echo "✅ Wings downloaded"

# Create systemd service
echo
echo "▶ Creating Wings service..."

cat > /etc/systemd/system/wings.service <<EOF
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
ExecStart=/etc/pterodactyl/wings
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable wings

echo "✅ Wings service created"

# SSL
echo
echo "▶ Generating SSL certificate..."
mkdir -p /etc/pterodactyl/certs

openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes \
  -out /etc/pterodactyl/certs/cert.pem \
  -keyout /etc/pterodactyl/certs/key.pem \
  -subj "/CN=pterodactyl-wings"

echo "✅ SSL generated"

# Auto-config
echo
read -p "Do you want to auto-configure Wings now? (y/n): " AUTOCONFIG

if [[ "$AUTOCONFIG" =~ ^[Yy]$ ]]; then
  echo
  echo "▶ Enter details from Pterodactyl Panel"

  read -p "Node UUID: " NODE_UUID
  read -p "Node Token ID: " TOKEN_ID
  read -p "Node Token: " TOKEN
  read -p "Panel URL (https://panel.example.com): " PANEL_URL

  cat > /etc/pterodactyl/config.yml <<EOF
debug: false
uuid: ${NODE_UUID}
token_id: ${TOKEN_ID}
token: ${TOKEN}
api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: true
    cert: /etc/pterodactyl/certs/cert.pem
    key: /etc/pterodactyl/certs/key.pem
remote: ${PANEL_URL}
EOF

  echo "✅ Wings configured"

  systemctl start wings
  echo "✅ Wings started"
else
  echo
  echo "ℹ️ Skipping auto-configuration"
  echo "ℹ️ You can configure later using:"
  echo "   nano /etc/pterodactyl/config.yml"
fi

echo
echo "==================================="
echo " 🎉 WINGS INSTALLATION COMPLETE"
echo "==================================="
echo
echo "Commands:"
echo "  Start : systemctl start wings"
echo "  Status: systemctl status wings"
echo "  Logs  : journalctl -u wings -f"
echo
