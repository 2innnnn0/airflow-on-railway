#!/usr/bin/env bash
set -euo pipefail

# Set defaults
AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"
PORT="${PORT:-8080}"

# Ensure log directory exists with proper permissions
mkdir -p "$LOG_DIR"

# Wait for database to be ready
echo "Waiting for database to be ready..."
airflow db check

# Start api-server (replaces webserver in Airflow 3.1+)
echo "Starting Airflow api-server on port $PORT..."
exec airflow api-server --port "$PORT"
