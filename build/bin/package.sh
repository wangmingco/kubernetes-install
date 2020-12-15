#!/bin/bash

type=$1
path=$2

function mvn_package() {
  mvn clean install
}

cd $path
if [ $type = 'maven' ]; then
  mvn_package
fi
