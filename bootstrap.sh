#!/usr/bin/env bash
set -euo pipefail
: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"
mkdir -p "$LOG_DIR"
chown -R airflow: "$LOG_DIR"

runuser -u airflow -s /bin/bash -c "airflow db migrate"

if ! runuser -u airflow -s /bin/bash -c "airflow users list" | grep -q "${AIRFLOW_ADMIN_USER:-admin}"; then
  runuser -u airflow -s /bin/bash -c "airflow users create \
    --role Admin \
    --username '${AIRFLOW_ADMIN_USER:-admin}' \
    --password '${AIRFLOW_ADMIN_PASSWORD:-admin}' \
    --email '${AIRFLOW_ADMIN_EMAIL:-admin@example.com}' \
    --firstname Admin --lastname User"
fi

runuser -u airflow -s /bin/bash -c "airflow scheduler &"
exec runuser -u airflow -s /bin/bash -c "airflow webserver --port '${PORT:-8080}' --hostname 0.0.0.0"