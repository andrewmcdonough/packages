#!/bin/bash

set -e

VERSION="0.9.9"
USER_VERSION="-ts1"

mkdir -p build
cd build

sudo apt-get install -y g++ libmysqlclient-dev

if [ ! -d sphinx-${VERSION} ]; then
  wget http://sphinxsearch.com/files/sphinx-${VERSION}.tar.gz
  tar -zxvf sphinx-${VERSION}.tar.gz
fi

cd sphinx-${VERSION}

if [ ! -d libstemmer_c/libstemmer ]; then
  wget http://snowball.tartarus.org/dist/libstemmer_c.tgz
  tar zxvf libstemmer_c.tgz
fi

mkdir -p installdir
installdir=`cd installdir && pwd`

./configure \
  --prefix=/usr \
  --disable-debug \
  --disable-dependency-tracking \
  --with-libstemmer
make
make install DESTDIR=$installdir

fpm -s dir -t deb -n ts-sphinx -v ${VERSION}${USER_VERSION} -C $installdir \
  -p sphinx-VERSION_ARCH.deb -d "libmysqlclient-dev" \
  -d "libc6 (>= 2.6)" \
  usr/bin usr/etc usr/var

mkdir -p ../../debs
mv *.deb ../../debs/
