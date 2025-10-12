# Airflow on Railway — One-shot Deploy

Single container + LocalExecutor + Railway Postgres + Volume.

## Deploy steps
1) Create Railway project
2) Add **PostgreSQL** service → copy `DATABASE_URL`
3) Create **Volume** and mount to `/opt/airflow/logs`
4) Add a new service from this repo (Dockerfile build)
5) Set Variables:
```
PORT=8080
AIRFLOW__CORE__EXECUTOR=LocalExecutor
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=${{PostgreSQL.DATABASE_URL}}
AIRFLOW__CORE__LOAD_EXAMPLES=False
AIRFLOW__CORE__FERNET_KEY=<python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())">
AIRFLOW__WEBSERVER__SECRET_KEY=<random>
AIRFLOW_ADMIN_USER=admin
AIRFLOW_ADMIN_PASSWORD=<strong>
AIRFLOW_ADMIN_EMAIL=<you@example.com>
```
6) Deploy → open the service URL → login with the admin user

## Notes
- Logs persist via Railway Volume at `/opt/airflow/logs`
- Put your DAGs in `dags/`
- If you need providers, add them to `requirements.txt` and uncomment in `Dockerfile`


# Apache Airflow Railway Repository Structure

```
airflow-railway/
├── webserver/
│   └── Dockerfile
├── scheduler/
│   └── Dockerfile
├── worker/
│   └── Dockerfile
├── triggerer/
│   └── Dockerfile
├── init/
│   └── Dockerfile
├── dags/
│   ├── example_dag.py
│   └── .gitkeep
├── plugins/
│   └── .gitkeep
├── .env.example
├── .gitignore
└── README.md
```