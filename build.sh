#!/bin/bash

set -e

export CON_NAME=php-fpm_t
export REG_URL=d.nicescale.com:5000
export IMAGE=php-fpm
export TAGS="5.6 5.6.10"
export BASE_IMAGE=microimages/alpine

docker pull $BASE_IMAGE

docker build -t microimages/$IMAGE .

#./test.sh

echo "---> Starting push microimages/$IMAGE:$VERSION"

for t in $TAGS; do
  docker tag -f microimages/$IMAGE microimages/$IMAGE:$t
done

docker push microimages/$IMAGE
