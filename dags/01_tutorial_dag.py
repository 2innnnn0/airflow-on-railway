import pendulum
from airflow.sdk import DAG
from airflow.providers.standard.operators.empty import EmptyOperator

default_args = dict(
    owner = 'bda', # 개별 DAG 관리자
    email = ['bda@airflow.com'],
    email_on_failure = False,
    retries = 3
    )

with DAG(
    dag_id="01_tutorial_dag",
    start_date=pendulum.datetime(2025, 8, 1, tz='Asia/Seoul'),
    schedule="30 10 * * *", # cron 표현식
    tags = ['20250824', 'BASIC'],
    default_args = default_args,
    catchup=False
):
    
    task1 = EmptyOperator(task_id="task1")
    task2 = EmptyOperator(task_id="task2")
    task3 = EmptyOperator(task_id="task3")
    task4 = EmptyOperator(task_id="task4")
    task5 = EmptyOperator(task_id="task5")

# task1 >> task2 >> task3 >> task4 >> task5
task1 >> [task2, task3] >> task4 >> task5
