FROM apache/airflow:2.9.3-python3.11

USER root
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins
COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod 755 /entrypoint-bootstrap.sh
# entrypoint는 root로 시작해 권한 정리 후 gosu로 떨어뜨림
ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]