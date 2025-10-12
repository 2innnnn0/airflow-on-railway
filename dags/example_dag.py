from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def print_hello():
    print("Hello from Airflow on Railway!")
    return "Hello World"

def print_date():
    print(f"Current date: {datetime.now()}")
    return datetime.now()

with DAG(
    'example_railway_dag',
    default_args=default_args,
    description='Example DAG for Railway deployment',
    schedule_interval=timedelta(days=1),
    catchup=False,
    tags=['example', 'railway'],
) as dag:

    t1 = BashOperator(
        task_id='print_date_bash',
        bash_command='date',
    )

    t2 = PythonOperator(
        task_id='print_hello',
        python_callable=print_hello,
    )

    t3 = PythonOperator(
        task_id='print_current_date',
        python_callable=print_date,
    )

    t1 >> [t2, t3]