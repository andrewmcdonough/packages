#!/bin/bash

set -e

cat /packages/keys/id_rsa.pub >> ~vagrant/.ssh/authorized_keys

cd /packages

apt-key add tribesports-pubkey.asc
sudo -u vagrant -H gpg --import tribesports-privkey.asc || true

echo 'deb http://packages.tribesports.com/ubuntu/ lucid-tribesports main' > /etc/apt/sources.list.d/tribesports.list

apt-get update
apt-get -y install aptitude
# Conditional stuff here to handle 10.04/12.04
DEBIAN_FRONTEND=noninteractive aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" full-upgrade
apt-get install -y make s3cmd ts-ruby

gem install fpm --no-ri --no-rdoc
