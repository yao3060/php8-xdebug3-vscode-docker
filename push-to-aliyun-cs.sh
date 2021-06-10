#!/usr/bin/env bash
set -aeuo pipefail

# create the dotenv file if it doesn't exist
if [ ! -f .env ]; then
  cp .env.default .env
fi

source .env

docker login --username=$ALIYUN_USERNAME $ALIYUN_CONTAINER_URL --password=$DOCKER_PASSWORD

PARALLEL=
if docker-compose build --help | grep -q 'parallel'; then
   PARALLEL="--parallel"
fi

docker-compose build ${PARALLEL}
docker-compose push
