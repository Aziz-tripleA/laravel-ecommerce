#!/usr/bin/env bash
# Per-boot reconciliation: ensure the MariaDB daemon is running and ready.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$REPO_ROOT/.cursor/db-up.sh"
