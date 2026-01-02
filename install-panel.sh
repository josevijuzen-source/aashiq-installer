#!/bin/bash
set -e

echo "Installing Pterodactyl Panel (Silent)..."

apt update -y
apt install -y curl tar unzip git redis-server mariadb-server nginx

apt install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt update -y
apt install -y php8.3 php8.3-{cli,fpm,gd,mysql,mbstring,bcmath,xml,curl,zip}

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzf panel.tar.gz
chmod -R 755 storage bootstrap/cache

cp .env.example .env
composer install --no-dev --optimize-autoloader

php artisan key:generate --force
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl

echo "✅ Panel installed successfully"
