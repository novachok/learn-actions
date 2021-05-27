#!/bin/bash

C_DIR="$(cd -- "$(dirname "$0/..")" >/dev/null 2>&1 ; pwd -P)"
TMP_DIR=$(mktemp -d -t ci-XXXX)

cp $C_DIR/app/src/input/*py $TMP_DIR
cd $TMP_DIR
zip -r $C_DIR/build/input.zip ./*

rm -rf $TMP_DIR/*
cp -R $C_DIR/app/src/output/. $TMP_DIR/
rm -rf $TMP_DIR/lib/__pycache__
cd $TMP_DIR
zip -r $C_DIR/build/output.zip ./*