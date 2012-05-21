#! /bin/bash

set -e

VERSION='1.4.13'
USER_VERSION='-ts1'

mkdir -p build
cd build

if [ ! -d memcached-${VERSION} ]; then
  wget http://memcached.googlecode.com/files/memcached-${VERSION}.tar.gz
  tar zxvf memcached-${VERSION}.tar.gz
fi

cd memcached-${VERSION}

./configure --prefix=/usr/local
make
make install DESTDIR=installdir

fpm -s dir -t deb -n ts-memcached -v ${VERSION}${USER_VERSION} -C installdir \
  -p memcached-VERSION_ARCH.deb -d 'libc6 (>= 2.6)' \
  -d 'libevent-1.4-2 (>= 1.4.13-stable)' -d 'perl' -d 'lsb-base (>= 3.2-13)' \
  usr/local/bin usr/local/include

mkdir -p ../../debs
mv *.deb ../../debs/
