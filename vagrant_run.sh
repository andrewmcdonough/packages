#!/bin/bash

set -e

ssh -i keys/id_rsa -o 'StrictHostKeyChecking no' -p 2222 vagrant@localhost -t "cd /packages && ./$1"
