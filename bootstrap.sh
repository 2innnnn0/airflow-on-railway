#!/usr/bin/env bash
set -euo pipefail

# Check required environment variables
: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

# Set defaults
AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"
PORT="${PORT:-8080}"
AIRFLOW_ADMIN_USER="${AIRFLOW_ADMIN_USER:-admin}"
AIRFLOW_ADMIN_PASSWORD="${AIRFLOW_ADMIN_PASSWORD:-admin}"
AIRFLOW_ADMIN_EMAIL="${AIRFLOW_ADMIN_EMAIL:-admin@example.com}"

# Ensure log directory exists with proper permissions
mkdir -p "$LOG_DIR"
chown -R airflow:0 "$LOG_DIR"

# Initialize database as airflow user
echo "Initializing Airflow database..."
gosu airflow airflow db migrate

# Create admin user if it doesn't exist (using FAB CLI in Airflow 3.1+)
echo "Checking for admin user..."
if ! gosu airflow airflow db-manager list-users --auth-manager-type fab | grep -q "$AIRFLOW_ADMIN_USER"; then
  echo "Creating admin user: $AIRFLOW_ADMIN_USER"
  gosu airflow airflow db-manager create-user \
    --auth-manager-type fab \
    --role Admin \
    --username "$AIRFLOW_ADMIN_USER" \
    --password "$AIRFLOW_ADMIN_PASSWORD" \
    --email "$AIRFLOW_ADMIN_EMAIL" \
    --firstname Admin \
    --lastname User
else
  echo "Admin user already exists"
fi

# Start scheduler in background
echo "Starting Airflow scheduler..."
gosu airflow airflow scheduler &

# Start api-server in foreground (replaces webserver in Airflow 3.1+)
echo "Starting Airflow api-server on port $PORT..."
exec gosu airflow airflow api-server --port "$PORT" --hostname 0.0.0.0