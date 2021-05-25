#!/bin/bash

C_DIR="$(cd -- "$(dirname "$0/..")" >/dev/null 2>&1 ; pwd -P)"
TMP_DIR=$(mktemp -d -t ci-XXXX)

echo $C_DIR
echo $TMP_DIR

cp $C_DIR/app/src/destination/*py $TMP_DIR
cd $TMP_DIR
zip $C_DIR/build/lambda.zip ./*
