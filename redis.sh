#! /bin/bash

set -e

VERSION='2.4.13'
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
PRGNAME='redis-server'
BENCHPRGNAME='redis-benchmark'
CLIPRGNAME='redis-cli'
CHECKDUMPPRGNAME='redis-check-dump'
CHECKAOFPRGNAME='redis-check-aof'

INSTALLDIR=installdir
BIN_DIR=$INSTALLDIR/usr/local/bin
CONF_DIR=$INSTALLDIR/etc/redis
INIT_DIR=$INSTALLDIR/etc/init.d

mkdir -p $BIN_DIR $CONF_DIR $INIT_DIR

for file in $PRGNAME $BENCHPRGNAME $CLIPRGNAME $CHECKDUMPPRGNAME $CHECKAOFPRGNAME; do
  cp -pf src/$file $BIN_DIR/
done

cp -pf redis.conf $CONF_DIR/

fpm -s dir -t deb -n ts-redis --provides redis-server --conflicts redis-server \
  -v ${VERSION}${USER_VERSION} -p redis-server-VERSION_ARCH.deb -C $INSTALLDIR \
  usr/local/bin etc/redis

mkdir -p ../../debs
mv *.deb ../../debs/
