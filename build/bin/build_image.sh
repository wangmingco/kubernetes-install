#!/bin/bash

repoName=$1
buildDate=$(date '+%Y-%m-%d-%H-%M-%S')

function build() {
  targetPath="/data/repo/${repoName}/target"

  echo "Target 路径 -> ${targetPath}"

  jarFile=$(ls "${targetPath}" | grep ".jar$")
  jarPath=${targetPath}"/"${jarFile}

  echo "Jar 路径 -> ${jarPath}"

  buildDir="/data/build/repo/${repoName}/${buildDate}"
  mkdir -p "${buildDir}"

  echo "Build 路径 -> ${buildDir}"

  cp "${jarPath}" "${buildDir}"
  cp /data/build/dockerfile/Dockerfile.jdk8 "${buildDir}"/Dockerfile.jdk8

  tagName=$(echo "${repoName//\//-}")
  dockerfile="${buildDir}/Dockerfile.jdk8"

  cd "${buildDir}"
  echo "构建地址: ${buildDir}"
  echo "开始执行构建命令: docker build -f ${dockerfile} -t ${tagName}:${buildDate} . 2>&1"

  docker login -u admin -p Harbor12345 http://"${publicIp}":10080
  docker build -f "${dockerfile}" -t "${publicIp}:10080/library/${tagName}":"${buildDate}" . --build-arg jarFile=${jarFile} 2>&1

  echo "${tagName} 所有镜像"
  docker images | grep "${tagName}"
}

function push() {
  docker push "${publicIp}":10080/library/"${tagName}:${buildDate}"
  docker logout
}

source /data/build/bin/common.sh
build
push
