#!/bin/sh

dryrun=$1

s3cmd/s3cmd $dryrun -c s3cfg-tribesports --acl-public --delete-removed sync repo/* s3://packages.tribesports.com/ubuntu/
