#!/bin/bash

set -e

VERSION='1.2.0'
USER_VERSION='-ts1'

mkdir -p build
cd build

# requires build-essential libssl-dev zlib1g-dev libpcre3-dev libxslt-dev libxml2dev
# libgeoip-dev
if [ ! -d nginx-${VERSION} ]; then
  wget http://nginx.org/download/nginx-${VERSION}.tar.gz
  tar zxvf nginx-${VERSION}.tar.gz
fi

cd nginx-${VERSION}

./configure \
  --prefix=/etc/nginx  \
  --sbin-path=/usr/sbin \
  --conf-path=/etc/nginx/nginx.conf  \
  --error-log-path=/var/log/nginx/error.log  \
  --http-client-body-temp-path=/var/lib/nginx/body  \
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi  \
  --http-log-path=/var/log/nginx/access.log  \
  --http-proxy-temp-path=/var/lib/nginx/proxy  \
  --http-scgi-temp-path=/var/lib/nginx/scgi  \
  --http-uwsgi-temp-path=/var/lib/nginx/uwsgi  \
  --lock-path=/var/lock/nginx.lock  \
  --pid-path=/var/run/nginx.pid  \
  --with-debug  \
  --with-http_addition_module  \
  --with-http_dav_module  \
  --with-http_geoip_module  \
  --with-http_gzip_static_module  \
  --with-http_realip_module  \
  --with-http_stub_status_module  \
  --with-http_ssl_module  \
  --with-http_sub_module  \
  --with-http_xslt_module  \
  --with-ipv6  \
  --with-sha1=/usr/include/openssl  \
  --with-md5=/usr/include/openssl  \
  --with-mail  \
  --with-mail_ssl_module

make
make install DESTDIR=installdir

fpm -s dir -t deb -n ts-nginx -v ${VERSION}${USER_VERSION} -C installdir \
  --provides nginx --conflicts nginx \
  -p nginx-VERSION_ARCH.deb \
  -d "libc6 (>= 2.10)" -d "libgeoip1 (>= 1.4.6.dfsg)" \
  -d "libpcre3 (>= 7.7)" -d "libssl0.9.8 (>= 0.9.8k-1)" \
  -d "libxml2 (>= 2.7.4)" -d "libxslt1.1 (>= 1.1.18)" \
  -d "zlib1g (>= 1:1.1.4)" \
  etc/nginx var

mkdir -p ../../debs
mv *.deb ../../debs/
