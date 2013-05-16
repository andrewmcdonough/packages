#!/bin/bash

set -e

if [[ -f "~vagrant/bootstrapped" ]]; then
  echo "Machine already bootstrapped, skipping..."
  exit 0
fi

# Add tribesports ubuntu repo to sources
gpg --keyserver pgp.mit.edu --recv-keys D07E8C22
gpg --export --armor D07E8C22 | apt-key add -
source /etc/lsb-release
cat > /etc/apt/sources.list.d/tribesports.list << EOF
deb http://packages.tribesports.com/ubuntu ${DISTRIB_CODENAME}-tribesports main
EOF

# Upgrade the HECK out of things.
apt-get update
apt-get -y install aptitude
# Junk necessary to get a properly non-interactive upgrade
DEBIAN_FRONTEND=noninteractive aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" full-upgrade
apt-get install -y ruby1.9.3 dpkg-dev

gem install fpm --no-ri --no-rdoc

touch ~vagrant/bootstrapped
