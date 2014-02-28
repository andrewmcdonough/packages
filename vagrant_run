#!/bin/bash

set -e

usage="usage: ./vagrant_run.sh SCRIPT [TARGET (precise32|precise64)]"

script=$1
if [[ ! -n "$script" ]]; then
  echo $usage
  exit 1
fi

target=$2
if [[ ! -n "$target" ]]; then
  target='precise32 precise64'
fi

for box in $target; do
  echo "Running ${script} on ${box}..."
  vagrant ssh $box -- -t "cd /vagrant && ./${script}"
done
