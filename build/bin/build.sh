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
  tagName=$2
  buildDate=$3
  buildHome=$4

  cd "${buildHome}/${buildDate}"

  dockerfile="${buildHome}/${buildDate}/Dockerfile"
  echo "${buildHome} 开始构建: docker build -f "${dockerfile}" -t "${publicIp}:10080/library/${tagName}":"${buildDate}" . 2>&1"
  docker build -f "${dockerfile}" -t "${publicIp}:10080/library/${tagName}":"${buildDate}" . 2>&1

  echo "${tagName} 所有镜像"
  docker images | grep "${tagName}"
}

function pushImage() {
  tagName=$2
  buildDate=$3

  docker login -u admin -p Harbor12345 http://"${publicIp}":10080
  docker push "${publicIp}":10080/library/"${tagName}:${buildDate}"
  docker logout
}

$1 $*
