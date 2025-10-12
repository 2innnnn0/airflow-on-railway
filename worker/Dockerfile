FROM apache/airflow:3.1.0-python3.12

USER root

# Install gosu for better privilege management
RUN apt-get update && apt-get install -y --no-install-recommends \
    gosu \
    && rm -rf /var/lib/apt/lists/* \
    && gosu nobody true

# Create necessary directories with proper ownership
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins \
    && chown -R airflow:0 /opt/airflow

# Install Python dependencies as airflow user
# COPY requirements.txt /requirements.txt
# USER airflow
# RUN pip install --no-cache-dir -r /requirements.txt

# Copy entrypoint script
USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER airflow
ENTRYPOINT ["/entrypoint.sh"]
CMD ["celery", "worker"]
