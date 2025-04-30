#!/bin/bash

WORKDIR="/home/edersond/airflow" # Diretorio de onde voce pretende rodar o airflow
mkdir -p $WORKDIR && cd $WORKDIR
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
mkdir -p ./dags ./logs ./plugins ./config
echo -e  "AIRFLOW_UID=$(id -u)" > .env
#colocar Dockerfile personalizado na pasta do projeto
