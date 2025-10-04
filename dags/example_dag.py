from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

# Airflow 3.1 compatible DAG
with DAG(
    dag_id="example_railway_hello",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",  # Updated from schedule_interval to schedule
    catchup=False,
    tags=["railway", "example"],
) as dag:
    hello = BashOperator(
        task_id="echo_hello",
        bash_command="echo 'Hello from Airflow 3.1 on Railway'"
    )
