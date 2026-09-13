#!/usr/bin/env bash
# Bring MariaDB up (idempotent) and ensure the application database + user exist.
set -euo pipefail

DB_NAME="${DB_DATABASE:-laravel}"
DB_USER="${DB_USERNAME:-laravel}"
DB_PASS="${DB_PASSWORD:-laravel}"

sudo mkdir -p /var/run/mysqld /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MariaDB data directory"
  sudo mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/tmp/mariadb-install.log 2>&1
fi

if ! sudo mysqladmin ping >/dev/null 2>&1; then
  sudo mysqld_safe --datadir=/var/lib/mysql >/tmp/mariadb.log 2>&1 &
  for _ in $(seq 1 60); do
    sudo mysqladmin ping >/dev/null 2>&1 && break
    sleep 1
  done
fi

sudo mysqladmin ping

sudo mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'127.0.0.1';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "MariaDB is up; database '${DB_NAME}' and user '${DB_USER}' are ready."
