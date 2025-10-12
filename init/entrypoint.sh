#!/usr/bin/env bash
set -euo pipefail

# Check required environment variables
: "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN:?AIRFLOW__DATABASE__SQL_ALCHEMY_CONN is required}"

# Set defaults
AIRFLOW_HOME="${AIRFLOW_HOME:-/opt/airflow}"
LOG_DIR="${AIRFLOW_HOME}/logs"
AIRFLOW_ADMIN_USER="${AIRFLOW_ADMIN_USER:-admin}"
AIRFLOW_ADMIN_PASSWORD="${AIRFLOW_ADMIN_PASSWORD:-admin}"
AIRFLOW_ADMIN_EMAIL="${AIRFLOW_ADMIN_EMAIL:-admin@example.com}"

# Ensure log directory exists with proper permissions
mkdir -p "$LOG_DIR"

# Initialize database
echo "Initializing Airflow database..."
airflow db migrate

# Create admin user if it doesn't exist (using FAB provider CLI)
echo "Checking for admin user..."
USER_EXISTS=$(airflow users list 2>/dev/null | grep -c "$AIRFLOW_ADMIN_USER" || echo "0")
if [ "$USER_EXISTS" -eq "0" ]; then
  echo "Creating admin user: $AIRFLOW_ADMIN_USER"
  airflow users create \
    --role Admin \
    --username "$AIRFLOW_ADMIN_USER" \
    --password "$AIRFLOW_ADMIN_PASSWORD" \
    --email "$AIRFLOW_ADMIN_EMAIL" \
    --firstname Admin \
    --lastname User
else
  echo "Admin user already exists"
fi

echo "Initialization complete!"
