#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_DIR="$(cd "${DEPLOY_DIR}/../.." && pwd)"

FRONTEND_DIST="${REPO_DIR}/ruoyi-ui/RuoYi-Vue3/dist"
BACKEND_JAR="${REPO_DIR}/ruoyi-admin/target/ruoyi-admin.jar"
SQL_DIR="${REPO_DIR}/sql"

echo "Preparing deployment artifacts in ${DEPLOY_DIR}"

if [[ ! -d "${FRONTEND_DIST}" ]]; then
  echo "Missing frontend dist: ${FRONTEND_DIST}"
  echo "Run the frontend build first, for example: yarn build:prod"
  exit 1
fi

if [[ ! -f "${BACKEND_JAR}" ]]; then
  echo "Missing backend jar: ${BACKEND_JAR}"
  echo "Run the backend build first, for example: mvn clean package -pl ruoyi-admin -am -DskipTests"
  exit 1
fi

mkdir -p "${DEPLOY_DIR}/artifacts/frontend"
mkdir -p "${DEPLOY_DIR}/artifacts/backend"
mkdir -p "${DEPLOY_DIR}/mysql/init"
mkdir -p "${DEPLOY_DIR}/data/mysql"
mkdir -p "${DEPLOY_DIR}/data/redis"
mkdir -p "${DEPLOY_DIR}/data/profile"
mkdir -p "${DEPLOY_DIR}/logs/backend"
mkdir -p "${DEPLOY_DIR}/logs/nginx"

rm -rf "${DEPLOY_DIR}/artifacts/frontend"
mkdir -p "${DEPLOY_DIR}/artifacts/frontend"
cp -R "${FRONTEND_DIST}/." "${DEPLOY_DIR}/artifacts/frontend/"

cp "${BACKEND_JAR}" "${DEPLOY_DIR}/artifacts/backend/ruoyi-admin.jar"

if compgen -G "${SQL_DIR}/*.sql" > /dev/null; then
  rm -f "${DEPLOY_DIR}/mysql/init/"*.sql

  cat > "${DEPLOY_DIR}/mysql/init/00-database-charset.sql" <<EOF
SET NAMES utf8mb4;
ALTER DATABASE \`${MYSQL_DATABASE:-ry-vue}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
EOF

  for sql_file in "${SQL_DIR}/"*.sql; do
    sql_name="$(basename "${sql_file}")"
    {
      printf '%s\n' "SET NAMES utf8mb4;"
      printf '%s\n' "SET character_set_client = utf8mb4;"
      printf '%s\n' "SET character_set_connection = utf8mb4;"
      printf '%s\n' "SET character_set_results = utf8mb4;"
      cat "${sql_file}"
    } > "${DEPLOY_DIR}/mysql/init/${sql_name}"
  done
fi

if [[ ! -f "${DEPLOY_DIR}/.env" ]]; then
  cp "${DEPLOY_DIR}/.env.example" "${DEPLOY_DIR}/.env"
  echo "Created ${DEPLOY_DIR}/.env from .env.example"
fi

echo "Artifacts ready."
echo "Frontend copied from: ${FRONTEND_DIST}"
echo "Backend copied from: ${BACKEND_JAR}"
echo "SQL copied from: ${SQL_DIR}"
