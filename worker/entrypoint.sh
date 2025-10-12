#!/usr/bin/env bash
set -euo pipefail

# Set defaults
AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"

# Ensure log directory exists with proper permissions
mkdir -p "$LOG_DIR"

# Wait for database to be ready
echo "Waiting for database to be ready..."
airflow db check

# Start celery worker
echo "Starting Airflow celery worker..."
exec airflow celery worker
