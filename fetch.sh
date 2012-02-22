#!/bin/bash
# Fetch existing debs from S3 into debs/ without overwriting local ones.

set -e
mkdir -p debs.new
s3cmd -c s3cfg-tribesports sync s3://tribesports-packages/pool/ debs.new/
cp debs/* debs.new
rm -rf debs
mv debs.new debs
