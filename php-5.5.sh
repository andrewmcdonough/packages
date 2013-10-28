#!/bin/bash

set -e

source /etc/lsb-release

VERSION="5.5.5"
USER_VERSION="-ts1"

mkdir -p build
cd build

sudo apt-get install -y libxml2-dev libmcrypt4 libmcrypt-dev

if [ ! -d ruby-${VERSION} ]; then
  tarball=php-${VERSION}.tar.gz
  if [ ! -f $tarball ]; then
    wget http://uk3.php.net/get/#{tarball}/from/a/mirror -O $tarball
    wget http://uk3.php.net/get/${tarball}/from/uk1.php.net/mirror -O $tarball
  fi
  tar zxvf $tarball
fi

cd php-${VERSION}

./configure \
  --prefix=/usr \
  --mandir=/usr/share/man  \
  --infodir=/usr/share/info \
  --with-mhash \
  --with-mcrypt \
  --with-pdo-mysql=mysqlnd \
  --with-mysql-sock=/var/mysql/mysql.sock \
  --with-mysql=mysqlnd  \
  --with-mysqli=mysqlnd \
  --with-libxml-dir=/usr 

make clean
make
INSTALL_ROOT=installdir make install 

fpm -s dir -t deb -n ts-php5 -v ${VERSION}${USER_VERSION} -C installdir \
  --provides php --provides php5 --conflicts php --conflicts php5 \
  -p php-VERSION_ARCH.deb \
  -d "libxml2-dev (>= 2.7.8)" \
  -d "libmcrypt4 (>= 2.5.8)" \
  -d "libmcrypt-dev (>= 2.5.8)" \
  usr/bin usr/etc usr/include usr/lib usr/share

mkdir -p ../../debs/${DISTRIB_CODENAME}-tribesports
mv *.deb ../../debs/${DISTRIB_CODENAME}-tribesports
