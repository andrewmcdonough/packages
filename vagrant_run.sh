#!/bin/bash

set -e

usage="usage: ./vagrant_run.sh SCRIPT [TARGET (lucid32|lucid64|precise32|precise64)]"

script=$1
if [ ! -n "$script" ]; then
  echo $usage
  exit 1
fi

case "$2" in
  lucid32)
    ports='2222'
    ;;
  lucid64)
    ports='2223'
    ;;
  precise32)
    ports='2224'
    ;;
  precise64)
    ports='2225'
    ;;
  '')
    ports='2222 2223 2224 2225'
    ;;
  *)
    echo $usage
    exit 1
    ;;
esac


for port in $ports; do
  ssh -i keys/id_rsa -o 'StrictHostKeyChecking no' -p $port -q vagrant@localhost -t "cd /packages && ./$1"
done
