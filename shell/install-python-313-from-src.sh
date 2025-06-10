#!/bin/bash
set -e
WORKDIR="/usr/src"
PYVERSION="3.13.3"
TARBALL="Python-$PYVERSION.tgz"
INSTALLDIR="Python-$PYVERSION"

sudo apt update 
sudo apt upgrade -y
sudo apt install -y \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libncurses-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev \
  git \
  make

cd $WORKDIR
sudo wget https://www.python.org/ftp/python/$PYVERSION/$TARBALL
sudo tar xzf $TARBALL
cd $INSTALLDIR
sudo ./configure --enable-optimizations
sudo make -j"$(nproc)"
sudo make altinstall  # altinstall para não sobrescrever o /usr/bin/python padrão
python3.13 --version


cd $WORKDIR
sudo rm -rf $INSTALLDIR
sudo rm -rf $TARBALL
