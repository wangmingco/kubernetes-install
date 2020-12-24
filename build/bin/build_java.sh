#!/bin/bash

source /data/build/bin/common.sh >/dev/null

function listPackageFile() {
  repoHome=$2
  cd ${repoHome}
  find ./ -name "pom.xml"
}

function package() {
  packageFullPath=$2
  execFullPath=$3
  buildHome=$4

  echo "打包目录: ${packageFullPath}, 执行文件目录:${execFullPath}, 构建目录:${buildHome}"

  cd ${packageFullPath}
  mvn clean install

  mkdir -p "${buildHome}"

  targetPath="${execFullPath}target"
  jarFile=$(ls "${targetPath}" | grep ".jar$")
  jarPath=${targetPath}"/"${jarFile}

  cp "${jarPath}" "${buildHome}"
  cp "/data/build/bin/run_java.sh" "${buildHome}"
  cp /data/build/dockerfile/Dockerfile.jdk8 "${buildHome}"/Dockerfile

  sed -i "s@run_program@runFatJar@g" "${buildHome}/run_java.sh"
  sed -i "s@jarNameParam@${jarFile}@g" "${buildHome}/run_java.sh"
}


$1 $*

if [ $? -ne 0 ]; then
  echo "failed"
else
  echo "succeed"
fi
