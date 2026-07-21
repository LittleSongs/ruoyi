#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

"${SCRIPT_DIR}/prepare-artifacts.sh"

cd "${DEPLOY_DIR}"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

docker compose up -d

echo
echo "Deployment started."
echo "Frontend: http://localhost:${NGINX_PORT:-80}"
echo "Backend API via Nginx: http://localhost:${NGINX_PORT:-80}/prod-api"
echo "Direct backend port: http://localhost:${BACKEND_PORT:-8080}"
