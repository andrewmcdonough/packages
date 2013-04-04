#!/bin/bash

set -e

cat /packages/keys/id_rsa.pub >> ~vagrant/.ssh/authorized_keys

cd /packages

apt-key add tribesports-pubkey.asc
sudo -u vagrant -H gpg --import tribesports-privkey.asc

echo 'deb http://packages.tribesports.com/ubuntu/ lucid-tribesports main' > /etc/apt/sources.list.d/tribesports.list

apt-get update
apt-get install -y make s3cmd ts-ruby

gem install fpm --no-ri --no-rdoc
