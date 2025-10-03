#!/usr/bin/env bash
set -euo pipefail

# Ensure DB URL exists
: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

# Initialize / migrate db
airflow db migrate

# Create admin user if not exists
if ! airflow users list | grep -q "${AIRFLOW_ADMIN_USER:-admin}"; then
  airflow users create \
    --role Admin \
    --username "${AIRFLOW_ADMIN_USER:-admin}" \
    --password "${AIRFLOW_ADMIN_PASSWORD:-admin}" \
    --email "${AIRFLOW_ADMIN_EMAIL:-admin@example.com}" \
    --firstname Admin --lastname User
fi

# Start scheduler in background
airflow scheduler &

# Start webserver on Railway's expected PORT
exec airflow webserver --port "${PORT:-8080}" --hostname 0.0.0.0
