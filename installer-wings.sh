#!/bin/bash
set -e

echo "=============================="
echo " Installing PterODACTYL WINGS "
echo "=============================="

# 1. Update system
apt update -y && apt upgrade -y

# 2. Install required packages
apt install -y curl ca-certificates gnupg lsb-release

# 3. Install Docker
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | bash
fi

systemctl enable --now docker

# 4. Install Wings binary
mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
chmod +x /usr/local/bin/wings

# 5. Create systemd service
cat > /etc/systemd/system/wings.service << 'EOF'
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30

[Install]
WantedBy=multi-user.target
EOF

# 6. Reload systemd
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable wings

echo ""
echo "=============================="
echo " Wings installed successfully "
echo "=============================="
echo ""
echo "NEXT STEP:"
echo "→ Go to PANEL > Nodes > Configuration"
echo "→ Copy the Wings config"
echo "→ Paste it into:"
echo "   nano /etc/pterodactyl/config.yml"
echo ""
echo "Then run:"
echo "systemctl start wings"
