#!/bin/bash
# Fetch existing debs from S3 into debs/ without overwriting local ones.

set -e
mkdir -p debs.new
s3cmd/s3cmd -c s3cfg-tribesports sync s3://packages.tribesports.com/ubuntu/pool/ debs.new/
cp -R debs/* debs.new
rm -rf debs
mv debs.new debs
