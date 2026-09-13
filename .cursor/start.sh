#!/usr/bin/env bash
# Per-boot startup: ensure MariaDB is running, then run the Laravel dev server
# in the foreground so its logs stay attached to the environment.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

bash "$REPO_ROOT/.cursor/db-up.sh"

exec php artisan serve --host=0.0.0.0 --port=8000
