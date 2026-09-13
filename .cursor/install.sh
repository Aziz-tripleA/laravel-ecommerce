#!/usr/bin/env bash
# Idempotent repository bootstrap for the Laravel e-commerce app.
# Installs PHP/JS dependencies, prepares .env, builds assets, migrates the DB,
# and ensures a development admin account exists.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

DB_USER="laravel"
DB_PASS="laravel"
ADMIN_EMAIL="admin@example.com"
ADMIN_PASSWORD="password"

echo "==> Installing PHP dependencies"
composer install --no-interaction --prefer-dist --no-progress

echo "==> Installing JS dependencies and building assets"
npm install --no-audit --no-fund
npm run production

echo "==> Preparing .env"
if [ ! -f .env ]; then
  cp .env.example .env
fi
sed -i "s/^DB_USERNAME=.*/DB_USERNAME=${DB_USER}/" .env
sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=${DB_PASS}/" .env
if ! grep -q '^APP_KEY=base64:' .env; then
  php artisan key:generate --force
fi

echo "==> Ensuring database is running"
bash "$REPO_ROOT/.cursor/db-up.sh"

echo "==> Running migrations"
php artisan migrate --force

echo "==> Ensuring development admin account exists"
php artisan tinker --execute="\App\Models\Admin::updateOrCreate(['email'=>'${ADMIN_EMAIL}'],['name'=>'Admin','password'=>bcrypt('${ADMIN_PASSWORD}')]);"

echo "==> Install complete. Admin login: ${ADMIN_EMAIL} / ${ADMIN_PASSWORD}"
