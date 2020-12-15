#!/bin/bash

repo_uri=$1
repo_name=$2
repo_path="/data/repo/"${repo_name}

function clone() {
  git clone ${repo_uri} ${repo_path}
}

function pull() {
  cd ${repo_path}
  git pull
}

if [ ! -d ${repo_path} ]; then
  clone
else
  pull
fi
