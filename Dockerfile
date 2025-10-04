FROM apache/airflow:3.1.0-python3.13

USER root
RUN apt-get update && apt-get install -y --no-install-recommends util-linux \
 && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins

# --- pip 는 airflow 사용자로 ---
COPY requirements.txt /requirements.txt
USER airflow
RUN pip install --no-cache-dir -r /requirements.txt
# --- 이후 루트로 돌아와 나머지 작업 ---
USER root

COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod 755 /entrypoint-bootstrap.sh
ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]