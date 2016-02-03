#!/bin/bash

set -xe

docker rm -f "$CON_NAME" > /dev/null 2>&1 || true
docker run -d --name $CON_NAME $IMAGE
sleep 1

PROGRAM=hello
cat <<EOF > /tmp/$PROGRAM.php
<?php
echo "Hello cSphere!"
?>
EOF
docker cp /tmp/$PROGRAM.php $CON_NAME:/app/
docker exec $CON_NAME ps ax|grep "php-fp[m]"
docker exec $CON_NAME php $PROGRAM.php

docker rm -f $CON_NAME

echo "---> The test pass"
