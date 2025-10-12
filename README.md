# Apache Airflow on Railway

Railway에 Apache Airflow를 다중 서비스로 배포하기 위한 레포지토리입니다.

## 📁 프로젝트 구조

```
airflow-railway/
├── webserver/          # Airflow 웹서버
│   └── Dockerfile
├── scheduler/          # Airflow 스케줄러
│   └── Dockerfile
├── worker/            # Airflow Worker (Celery)
│   └── Dockerfile
├── triggerer/         # Airflow Triggerer
│   └── Dockerfile
├── init/              # DB 초기화 (1회 실행)
│   ├── Dockerfile
│   └── init.sh
├── dags/              # DAG 파일들
│   └── example_dag.py
├── plugins/           # 커스텀 플러그인
├── requirements.txt   # 추가 Python 패키지
├── .env.example       # 환경변수 예시
└── README.md
```

## 🚀 Railway 배포 가이드

### 1단계: 데이터베이스 생성

Railway 프로젝트에서:

1. **New** → **Database** → **PostgreSQL** 선택
2. **New** → **Database** → **Redis** 선택

### 2단계: Fernet Key 생성

Python에서 실행:

```python
from cryptography.fernet import Fernet
print(Fernet.generate_key().decode())
```

생성된 키를 복사해두세요.

### 3단계: Init 서비스 배포 (DB 초기화)

1. **New** → **GitHub Repo** 선택
2. 이 레포지토리 연결
3. **Settings** 설정:
   - **Root Directory**: `/init`
   - **환경변수 추가** (아래 참고)
4. Deploy 후 로그 확인
5. 성공하면 이 서비스 삭제 (1회성)

### 4단계: Webserver 서비스 배포

1. **New** → **GitHub Repo** 선택
2. **Settings** 설정:
   - **Root Directory**: `/webserver`
   - **환경변수 추가** (아래 참고)
3. **Generate Domain** 클릭

### 5단계: Scheduler 서비스 배포

1. **New** → **GitHub Repo** 선택
2. **Settings** 설정:
   - **Root Directory**: `/scheduler`
   - **환경변수**: Webserver와 동일

### 6단계: Worker 서비스 배포

1. **New** → **GitHub Repo** 선택
2. **Settings** 설정:
   - **Root Directory**: `/worker`
   - **환경변수**: Webserver와 동일

### 7단계: Triggerer 서비스 배포 (선택사항)

1. **New** → **GitHub Repo** 선택
2. **Settings** 설정:
   - **Root Directory**: `/triggerer`
   - **환경변수**: Webserver와 동일

## 🔧 환경변수 설정

모든 Airflow 서비스에 다음 환경변수를 추가하세요:

### 필수 환경변수

```bash
# Core
AIRFLOW__CORE__EXECUTOR=CeleryExecutor
AIRFLOW__CORE__LOAD_EXAMPLES=False
AIRFLOW__CORE__FERNET_KEY=<생성한-fernet-key>
AIRFLOW__WEBSERVER__SECRET_KEY=<랜덤-문자열>

# Database (Railway 변수 참조 사용)
AIRFLOW__CORE__SQL_ALCHEMY_CONN=${{Postgres.DATABASE_URL}}

# Celery
AIRFLOW__CELERY__BROKER_URL=${{Redis.REDIS_URL}}
AIRFLOW__CELERY__RESULT_BACKEND=db+${{Postgres.DATABASE_URL}}

# API
AIRFLOW__API__AUTH_BACKENDS=airflow.api.auth.backend.basic_auth
```

### Init 서비스 추가 환경변수

```bash
AIRFLOW_ADMIN_USERNAME=admin
AIRFLOW_ADMIN_PASSWORD=<강력한-비밀번호>
AIRFLOW_ADMIN_EMAIL=admin@example.com
```

## 🔗 Private Networking 사용 (선택사항)

Railway 변수 참조 대신 Private Networking을 사용하려면:

```bash
# PostgreSQL
AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://postgres:<PASSWORD>@postgres.railway.internal:5432/railway

# Redis
AIRFLOW__CELERY__BROKER_URL=redis://default:<PASSWORD>@redis.railway.internal:6379/0
```

## 📝 DAG 추가하기

1. `dags/` 폴더에 Python 파일 추가
2. Git push
3. Railway가 자동으로 재배포

## 🔍 트러블슈팅

### DB 연결 실패
- PostgreSQL 서비스가 실행 중인지 확인
- 환경변수 `${{Postgres.DATABASE_URL}}` 올바른지 확인

### Worker가 Task를 실행하지 않음
- Redis 연결 확인
- Worker 서비스 로그 확인
- Executor가 `CeleryExecutor`로 설정되었는지 확인

### 서비스 간 통신 안됨
- 모든 서비스가 같은 Railway 프로젝트에 있는지 확인
- Private Networking 사용 시 IPv6 지원 확인

## 📊 접속 정보

- **Webserver URL**: Railway에서 생성된 도메인
- **Username**: `.env`에서 설정한 값 (기본: `admin`)
- **Password**: `.env`에서 설정한 값 (기본: `admin`)

## ⚠️ 주의사항

1. **프로덕션 사용 시 반드시 변경**:
   - `AIRFLOW__CORE__FERNET_KEY`
   - `AIRFLOW__WEBSERVER__SECRET_KEY`
   - Admin 비밀번호

2. **비용**: Worker를 여러 개 띄우면 비용 증가

3. **로그**: Railway의 persistent storage가 없으므로 로그는 Railway 대시보드에서 확인

4. **DAG 업데이트**: Git push 시 자동 재배포

## 📚 참고 자료

- [Apache Airflow 공식 문서](https://airflow.apache.org/docs/)
- [Railway 공식 문서](https://docs.railway.com/)
- [Railway Private Networking](https://docs.railway.com/reference/private-networking)

## 🤝 기여

이슈나 PR은 언제나 환영합니다!

## 📄 라이선스

MIT License