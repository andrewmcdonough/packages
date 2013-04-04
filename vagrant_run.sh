#!/bin/bash

set -e

usage="usage: ./vagrant_run.sh SCRIPT [TARGET (x86|amd64)]"

script=$1
if [ ! -n "$script" ]; then
  echo $usage
  exit 1
fi

case "$2" in
  x86)
    ports='2222'
    ;;
  amd64)
    ports='2223'
    ;;
  '')
    ports='2222 2223'
    ;;
  *)
    echo $usage
    exit 1
    ;;
esac


for port in $ports; do
  ssh -i keys/id_rsa -o 'StrictHostKeyChecking no' -p $port -q vagrant@localhost -t "cd /packages && ./$1"
done
