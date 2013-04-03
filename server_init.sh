#!/bin/bash

set -e

cd /vagrant_share

apt-key add tribesports-pubkey.asc
sudo -u vagrant gpg --import tribesports-privkey.asc

echo 'deb http://packages.tribesports.com/ubuntu/ lucid-tribesports main' > /etc/apt/sources.list.d/tribesports.list

apt-get update
apt-get install -y make s3cmd ts-ruby

gem install fpm --no-ri --no-rdoc
