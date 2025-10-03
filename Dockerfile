FROM apache/airflow:2.9.3-python3.11

USER root
RUN apt-get update && apt-get install -y --no-install-recommends gosu \
 && rm -rf /var/lib/apt/lists/*

# 이하 동일
COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod 755 /entrypoint-bootstrap.sh
ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]