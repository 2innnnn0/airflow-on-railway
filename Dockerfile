FROM apache/airflow:3.1.0-python3.12

USER root
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins

# 필요 시 프로바이더 설치 활성화
# COPY requirements.txt /requirements.txt
# RUN pip install --no-cache-dir -r /requirements.txt

COPY dags/ /opt/airflow/dags/
COPY bootstrap.sh /entrypoint-bootstrap.sh
RUN chmod 755 /entrypoint-bootstrap.sh

# root로 시작 → 스크립트에서 로그 볼륨 chown 후 airflow 사용자로 실행
ENTRYPOINT ["/bin/bash", "/entrypoint-bootstrap.sh"]