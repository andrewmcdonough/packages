#!/bin/bash
# Build a repository from the debs in debs/.
# Shamelessly yoinked from http://github.com/alphagov/packages

set -e
DISTRIBUTIONS="lucid-tribesports"
COMPONENTS="main"
ARCHITECTURES="amd64 i386"

rm -rf repo
mkdir -p repo/pool
cp debs/*.deb repo/pool/

cd repo

for dist in $DISTRIBUTIONS; do
  for comp in $COMPONENTS; do
    for arch in $ARCHITECTURES; do
      path=dists/$dist/$comp/binary-$arch
      mkdir -p $path
      cat >$path/Release <<END
Archive: tribesports
Component: $comp
Origin: Tribesports Ltd
Label: Tribesports Deployment Repository
Architecture: $arch
END
      dpkg-scanpackages -a $arch pool /dev/null > $path/Packages
      gzip -9c < $path/Packages > $path/Packages.gz
    done
  done
  cat > Release <<END
Origin: Tribesports Ltd
Label: Tribesports Deployment Repository
Suite: $dist
Codename: $dist
Architectures: $ARCHITECTURES
Components: $COMPONENTS
Description: Tribesports package respository
END
  apt-ftparchive release dists/$dist >> Release
  gpg -abs \
    --local-user 'Tribesports <tech@tribesports.com>' \
    --output dists/$dist/Release.gpg \
    Release
  mv Release dists/$dist/
done
