#! /bin/bash

set -e

VERSION='1.4.13'
USER_VERSION='-ts1'

mkdir -p build
cd build

sudo apt-get install -y libevent-dev lsb-base perl

if [ ! -d memcached-${VERSION} ]; then
  wget http://memcached.googlecode.com/files/memcached-${VERSION}.tar.gz
  tar zxvf memcached-${VERSION}.tar.gz
fi

cd memcached-${VERSION}

./configure --prefix=/usr

make
make install DESTDIR=installdir
scripts_dir=installdir/usr/share/memcached/scripts
mkdir -p ${scripts_dir}
cp -pf scripts/{memcached-tool,start-memcached,memcached-init} ${scripts_dir}/

fpm -s dir -t deb -n ts-memcached -v ${VERSION}${USER_VERSION} -C installdir \
  --provides memcached --conflicts memcached \
  -p memcached-VERSION_ARCH.deb -d 'libc6 (>= 2.6)' \
  -d 'libevent-1.4-2 (>= 1.4.13-stable)' -d 'perl' -d 'lsb-base (>= 3.2-13)' \
  usr/bin usr/include usr/share

mkdir -p ../../debs
mv *.deb ../../debs/
