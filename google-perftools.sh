#!/bin/bash

set -e

source /etc/lsb-release

VERSION="2.0"
USER_VERSION="-ts1"

# gperftools doesn't like being built in a vagrant shared folder,
# so build it instead in the vagrant user's home directory
cd ~vagrant

mkdir -p build
cd build

sudo apt-get install -y libunwind7 libunwind7-dev

if [ ! -d gperftools-${VERSION} ]; then
  tarball=gperftools-${VERSION}.tar.gz
  if [ ! -f $tarball ]; then
    wget https://gperftools.googlecode.com/files/$tarball -O $tarball
  fi
  tar zxvf $tarball
fi

cd gperftools-${VERSION}

./configure \
  --prefix=/opt

make clean
make
make install DESTDIR=`pwd -P`/installdir

fpm -s dir -t deb -n ts-google-perftools -v ${VERSION}${USER_VERSION} -C installdir \
  --provides google-perftools --conflicts google-perftools \
  -d "libunwind7 (>= 0.99)" \
  opt

mkdir -p /vagrant/debs/${DISTRIB_CODENAME}-tribesports
mv *.deb /vagrant/debs/${DISTRIB_CODENAME}-tribesports
