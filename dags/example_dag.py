from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="example_railway_hello",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["railway","example"],
) as dag:
    hello = BashOperator(
        task_id="echo_hello",
        bash_command="echo 'Hello from Airflow on Railway'"
    )
