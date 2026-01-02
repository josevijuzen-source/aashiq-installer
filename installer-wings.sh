#!/bin/bash
set -e

clear
echo "======================================"
echo "        AASHIQ | WINGS INSTALLER       "
echo "======================================"
echo

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

echo "▶ Updating system..."
apt update -y

echo "▶ Installing dependencies..."
apt install -y curl ca-certificates gnupg lsb-release jq tar unzip

# -------------------------------
# Docker (OFFICIAL METHOD)
# -------------------------------
echo "▶ Installing Docker..."

apt remove -y docker docker-engine docker.io containerd runc || true

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "✅ Docker installed"

# -------------------------------
# Download Wings
# -------------------------------
echo
echo "▶ Downloading Wings..."

mkdir -p /etc/pterodactyl
cd /etc/pterodactyl

curl -L -o wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
chmod +x wings

echo "✅ Wings binary downloaded"

# -------------------------------
# Systemd service
# -------------------------------
echo
echo "▶ Creating Wings service..."

cat <<EOF >/etc/systemd/system/wings.service
[Unit]
Description=Pterodactyl Wings
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/etc/pterodactyl/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable wings

# -------------------------------
# Auto-config Wings
# -------------------------------
echo
read -p "Do you want to auto-configure Wings now? (y/N): " AUTO

if [[ "$AUTO" =~ ^[Yy]$ ]]; then
  echo
  echo "Enter details from Pterodactyl Panel → Node → Configuration"

  read -p "Panel URL (https://panel.example.com): " PANEL_URL
  read -p "Node UUID: " NODE_UUID
  read -p "Node Token ID: " TOKEN_ID
  read -p "Node Token: " TOKEN

  cat <<EOF >/etc/pterodactyl/config.yml
debug: false
uuid: $NODE_UUID
token_id: $TOKEN_ID
token: $TOKEN
api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: false
EOF

  systemctl start wings
  echo
  echo "✅ Wings configured & started"
else
  echo
  echo "ℹ You can configure later using:"
  echo "   nano /etc/pterodactyl/config.yml"
  echo "   systemctl start wings"
fi

echo
echo "======================================"
echo "✅ WINGS INSTALLATION COMPLETE"
echo "======================================"
echo
echo "Check status: systemctl status wings"
echo "Logs: journalctl -u wings -f"
