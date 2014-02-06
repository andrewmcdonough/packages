#!/bin/bash

set -e

source /etc/lsb-release

VERSION="2.2.4"
USER_VERSION="-ts1"

debdir=`pwd -P`/debs/${DISTRIB_CODENAME}-tribesports

mkdir -p build/php-redis
cd build/php-redis

sudo apt-get install -y php5-dev

if [[ ! -d php-redis-${VERSION} ]]; then
  tarball=php-redis-${VERSION}.tar.gz
  if [[ ! -f $tarball ]]; then
    wget http://pecl.php.net/get/redis-${VERSION}.tgz -O $tarball
  fi
  tar zxvf $tarball
fi

cd redis-${VERSION}

phpize
./configure

make clean
make
INSTALL_ROOT=installdir make install

mkdir -p installdir/etc/php5/conf.d
echo "extension=redis.so" > installdir/etc/php5/conf.d/redis.ini

fpm -s dir -t deb -n ts-php-redis -v ${VERSION}${USER_VERSION} -C installdir \
  -p php-redis-VERSION_ARCH.deb \
  -d "php5 (>= 5.3.0)" \
  etc/php5 usr/lib

mkdir -p $debdir
mv *.deb $debdir
