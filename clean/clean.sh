#!/bin/bash

PROGNAME=$0

# Setup script directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD/.."; fi

cd $DIR/ci/
docker-compose down
rm docker-compose.yml
rm $DIR/installation/log/installation.log
docker volume prune -f
docker network prune -f
docker rm $(docker ps -a -q) -f
docker rmi $(docker images -a -q) -f
