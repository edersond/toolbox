REPODIR=$(pwd)
VOLDIR=/usr/local/pgsql
BUILDDIR=~/postgres

function makedirs() {
    if [ ! -d "$VOLDIR" ]; then
        sudo mkdir -p "$VOLDIR"
    fi
    if [ ! -w "$VOLDIR" ]; then
        sudo chown -R "$USER:$USER" "$VOLDIR"
    fi
    if [ ! -d "$BUILDDIR" ]; then
        sudo mkdir -p "$BUILDDIR"
    fi
    if [ ! -w "$BUILDDIR" ]; then
        sudo chown -R "$USER:$USER" "$BUILDDIR"
    fi
}
makedirs

cp -r $REPODIR/Dockerfiles/postgres-17/Dockerfile $BUILDDIR
cd $BUILDDIR

# Remove any existing container
if docker ps -a --format '{{.Names}}' | grep -q "^postgres-17\$"; then
    echo "Removing existing container postgres-17"
    docker rm -f postgres-17
fi
# Remove any existing vol data
if [ "$(ls -A $VOLDIR)" ]; then
    echo "Cleaning existing data in $VOLDIR"
    rm -rf $VOLDIR/*
fi

docker build -t postgres:17 .

docker run -d \
    --name postgres-17 \
    -p 5435:5432 \
    -v $VOLDIR:/var/lib/postgresql/data \
    postgres:17