FROM apache/airflow:2.9.3-python3.11

USER root
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins \
 && chown -R airflow: /opt/airflow
USER airflow

ENV AIRFLOW_HOME=/opt/airflow

# Optional: install extra providers via constraints (uncomment if needed)
# COPY requirements.txt /requirements.txt
# RUN pip install --no-cache-dir -r /requirements.txt

COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod +x /entrypoint-bootstrap.sh

ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]
