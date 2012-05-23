#! /bin/bash

set -e

VERSION='2.4.14'
USER_VERSION='-ts1'

mkdir -p build
cd build

if [ ! -d redis-${VERSION} ]; then
  wget http://redis.googlecode.com/files/redis-${VERSION}.tar.gz
  tar -zxvf redis-${VERSION}.tar.gz
fi

cd redis-${VERSION}

make

# Redis's Makefile doesn't respect DESTDIR, so do all this copying manually:
INSTALLDIR=installdir
BIN_DIR=$INSTALLDIR/usr/bin
CONF_DIR=$INSTALLDIR/etc/redis
INIT_DIR=$INSTALLDIR/etc/init.d

mkdir -p $BIN_DIR $CONF_DIR $INIT_DIR

for prog in server benchmark cli check-dump check-aof; do
  cp -pf src/redis-${prog} $BIN_DIR/
done

cp -pf redis.conf $CONF_DIR/

fpm -s dir -t deb -n ts-redis --provides redis-server --conflicts redis-server \
  -v ${VERSION}${USER_VERSION} -p redis-server-VERSION_ARCH.deb -C $INSTALLDIR \
  -d 'libc6 (>= 2.7)' \
  usr/bin etc/redis

mkdir -p ../../debs
mv *.deb ../../debs/
