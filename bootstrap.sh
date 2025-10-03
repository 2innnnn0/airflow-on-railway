#!/usr/bin/env bash
set -euo pipefail

: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

# 볼륨 권한 정리
export AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"
mkdir -p "${LOG_DIR}"
chown -R airflow: "${LOG_DIR}"

# Airflow 작업은 airflow 사용자로 실행
gosu airflow airflow db migrate

if ! gosu airflow airflow users list | grep -q "${AIRFLOW_ADMIN_USER:-admin}"; then
  gosu airflow airflow users create \
    --role Admin \
    --username "${AIRFLOW_ADMIN_USER:-admin}" \
    --password "${AIRFLOW_ADMIN_PASSWORD:-admin}" \
    --email "${AIRFLOW_ADMIN_EMAIL:-admin@example.com}" \
    --firstname Admin --lastname User
fi

gosu airflow airflow scheduler &

exec gosu airflow airflow webserver --port "${PORT:-8080}" --hostname 0.0.0.0