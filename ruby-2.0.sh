#!/bin/bash

# Shamelessly yoinked from http://github.com/alphagov/packages, and mildly
# tweaked to remove some configuration optiosn that ruby completely ignores.

set -e

source /etc/lsb-release

VERSION="2.0.0-p247"
USER_VERSION="-ts1"

case "$DISTRIB_CODENAME" in
  lucid)
    libffi='libffi5'
    ffi_version='>= 3.0.4'
    ;;
  precise)
    libffi='libffi6'
    ffi_version='>= 3.0.10'
    ;;
  *)
    echo "Unsupported version of ubuntu"
    exit 1
    ;;
esac

mkdir -p build
cd build

sudo apt-get install -y build-essential libssl-dev libreadline6-dev \
  zlib1g-dev libyaml-dev libyaml-0-2 libffi-dev libgdbm-dev \
  libncurses5-dev

if [ ! -d ruby-${VERSION} ]; then
  tarball=ruby-${VERSION}.tar.gz
  if [ ! -f $tarball ]; then
    wget http://ftp.ruby-lang.org/pub/ruby/2.0/${tarball} -O $tarball
  fi
  tar zxvf $tarball
fi

cd ruby-${VERSION}

./configure \
  --prefix=/usr \
  --with-opt-dir=/usr \
  --disable-install-doc \
  --without-X11

make clean
make
make install DESTDIR=installdir

fpm -s dir -t deb -n ts-ruby2.0 -v ${VERSION}${USER_VERSION} -C installdir \
  --provides ruby --provides ruby1.9.3 --conflicts ruby --conflicts ruby1.9.3 \
  -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "${libffi} (${ffi_version})" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  -d "libyaml-0-2 (>= 0.1.3-1)" \
  usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs/${DISTRIB_CODENAME}-tribesports
mv *.deb ../../debs/${DISTRIB_CODENAME}-tribesports
