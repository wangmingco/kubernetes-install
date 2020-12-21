#!/bin/bash

mkdir -p /data/build/{package,repo}

cp -r $HOME/kubernetes-install/build/* /data/build
cp $HOME/kubernetes-install/common.sh /data/build/bin
