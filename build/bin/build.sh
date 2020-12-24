#!/bin/bash

source /data/build/bin/common.sh > /dev/null

function cloneOrPull() {
  repo_uri=$2
  repo_name=$3
  repo_home=$4

  cd ${repo_home}
  if [ ! -d ${repo_name} ]; then
    git clone ${repo_uri}
  else
    cd ${repo_home}/${repo_name}
    git pull
  fi
}

function buildImage() {
  image=$2
  buildHome=$3
  mirror=$4

  cd "${buildHome}"
  echo "${buildHome} 开始构建: docker build -f ./Dockerfile -t "${image}" --build-arg mirror=${mirror} . 2>&1"
  docker build -f ./Dockerfile -t "${image}" --build-arg mirror=${mirror} . 2>&1

  echo "${image} 所有镜像"
  docker images "${image}"
}

function pushImage() {
  image=$2

  echo "开始推送镜像: ${image}"

  docker login -u admin -p Harbor12345 http://"${publicIp}":10080
  docker push "${image}"
  docker logout
}


$1 $*

if [ $? -ne 0 ]; then
    echo "failed"
else
    echo "succeed"
fi
