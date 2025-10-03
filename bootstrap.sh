#!/usr/bin/env bash
set -euo pipefail

: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"

# 볼륨 권한 보정
mkdir -p "$LOG_DIR"
chown -R airflow: "$LOG_DIR"

# DB 마이그레이션
su -s /bin/bash -c "airflow db migrate" airflow

# Admin 사용자 보장
if ! su -s /bin/bash -c "airflow users list" airflow | grep -q "${AIRFLOW_ADMIN_USER:-admin}"; then
  su -s /bin/bash -c "airflow users create \
    --role Admin \
    --username '${AIRFLOW_ADMIN_USER:-admin}' \
    --password '${AIRFLOW_ADMIN_PASSWORD:-admin}' \
    --email '${AIRFLOW_ADMIN_EMAIL:-admin@example.com}' \
    --firstname Admin --lastname User" airflow
fi

# 스케줄러 + 웹서버
su -s /bin/bash -c "airflow scheduler &" airflow
exec su -s /bin/bash -c "airflow webserver --port '${PORT:-8080}' --hostname 0.0.0.0" airflow