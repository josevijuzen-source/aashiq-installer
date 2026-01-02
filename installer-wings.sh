
#!/bin/bash
set -e

echo "=============================="
echo " AASHIQ | WINGS INSTALLER"
echo "=============================="

# Update system
apt update -y
apt install -y ca-certificates curl gnupg lsb-release

# Remove old docker if exists
apt remove -y docker docker-engine docker.io containerd runc || true

# Docker GPG
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# ⚠️ FORCE JAMMY (Ubuntu 22.04 repo) – FIX
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu jammy stable" \
> /etc/apt/sources.list.d/docker.list

apt update -y

# Install Docker
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Enable Docker
systemctl enable docker
systemctl start docker

# Test Docker
docker run hello-world

# Install Wings
mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
chmod +x /usr/local/bin/wings

# Create service
cat > /etc/systemd/system/wings.service <<EOF
[Unit]
Description=Pterodactyl Wings
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
ExecStart=/usr/local/bin/wings
Restart=on-failure
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wings

echo "=============================="
echo " Wings installed successfully"
echo " Next: Configure node in panel"
echo "=============================="
