#!/bin/sh

s3cmd/s3cmd -c s3cfg-tribesports --acl-public --delete-removed sync repo/* s3://tribesports-packages/
