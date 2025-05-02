#!/bin/bash
REPODIR=$(pwd)
WORKDIR="/home/bagaceitor/airflow" # Diretorio de onde voce pretende rodar o airflow
mkdir -p $WORKDIR && cd $WORKDIR
cp $REPODIR/Dockerfiles/airflow-3/docker-compose.yaml $WORKDIR
cp $REPODIR/Dockerfiles/airflow-3/Dockerfile $WORKDIR
mkdir -p ./dags ./logs ./plugins ./config

FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
JWT_SECRET=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
echo -e  "AIRFLOW_UID=$(id -u)" > .env
echo "AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}" >> .env
echo "AIRFLOW__API_AUTH__JWT_SECRET=${JWT_SECRET}" >> .env

docker-compose build
docker compose up airflow-init
docker compose up -d