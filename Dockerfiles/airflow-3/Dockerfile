FROM apache/airflow:3.0.0-python3.12
#VEM COM UM DEBIAN BOOKWORM

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev \
    libffi-dev \
    libssl-dev \
    gcc \
    g++ \
    make \
    python3-dev \
    curl \
    git

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER airflow
