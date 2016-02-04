#!/bin/bash

set -xe

export CON_NAME=php-fpm_t
export REG_URL=index.csphere.cn
export IMAGE=microimages/php-fpm
export TAGS="5.6 5.6.17"
export BASE_IMAGE=microimages/alpine

docker pull $BASE_IMAGE
./test.sh

docker build -t $IMAGE .

docker tag -f $IMAGE $REG_URL/$IMAGE
for t in $TAGS; do
  docker tag -f $IMAGE $REG_URL/$IMAGE:$t
  docker tag -f $IMAGE $IMAGE:$t
done

docker push $IMAGE
docker push $REG_URL/$IMAGE
