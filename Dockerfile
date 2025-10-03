FROM apache/airflow:2.9.3-python3.11

USER root
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins
COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod 755 /entrypoint-bootstrap.sh && chown -R airflow: /opt/airflow /entrypoint-bootstrap.sh

USER airflow
ENV AIRFLOW_HOME=/opt/airflow
ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]