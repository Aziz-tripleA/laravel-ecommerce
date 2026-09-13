#!/usr/bin/env bash
# Idempotently install the system-level toolchain the app needs:
# PHP 8.0 (+ extensions), MariaDB, and Composer. Node.js ships with the
# default Cloud Agent base image, so it is only installed if missing.
#
# With environment builds enabled, `install` runs once and its result is baked
# into the environment snapshot, so provisioning here does not run on every boot.
set -euo pipefail

if ! command -v php >/dev/null 2>&1 || ! php -v 2>/dev/null | grep -q 'PHP 8.0'; then
  echo "==> Installing PHP 8.0 and extensions"
  sudo add-apt-repository -y ppa:ondrej/php
  sudo apt-get update -y
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php8.0-cli php8.0-mysql php8.0-mbstring php8.0-xml php8.0-bcmath \
    php8.0-curl php8.0-zip php8.0-gd php8.0-sqlite3 php8.0-intl unzip
  sudo update-alternatives --set php /usr/bin/php8.0 || true
fi

if ! command -v mariadbd >/dev/null 2>&1 && ! command -v mysqld >/dev/null 2>&1; then
  echo "==> Installing MariaDB server"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server
fi

if ! command -v composer >/dev/null 2>&1; then
  echo "==> Installing Composer"
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

if ! command -v node >/dev/null 2>&1; then
  echo "==> Installing Node.js 22"
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
fi

echo "==> System toolchain ready:"
php -v | head -1
composer --version
node -v
