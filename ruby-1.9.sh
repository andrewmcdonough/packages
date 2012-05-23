#!/bin/bash

# Shamelessly yoinked from http://github.com/alphagov/packages, and mildly
# tweaked to remove some configuration optiosn that ruby completely ignores.

set -e

VERSION="1.9.3-p125"
USER_VERSION="-ts1"

mkdir -p build
cd build

# requires build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev libyaml-0-2
if [ ! -d ruby-${VERSION} ]; then
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${VERSION}.tar.gz
  tar -zxvf ruby-${VERSION}.tar.gz
fi

cd ruby-${VERSION}

./configure \
  --prefix=/usr \
  --with-opt-dir=/usr
make
make install DESTDIR=installdir

fpm -s dir -t deb -n ts-ruby -v ${VERSION}${USER_VERSION} -C installdir \
  --provides ruby --conflicts ruby \
  -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi5 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  -d "libyaml-0-2 (>= 0.1.3-1)" \
  usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs
mv *.deb ../../debs/
