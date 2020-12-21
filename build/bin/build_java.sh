#!/bin/bash

source /data/build/bin/common.sh > /dev/null

function listPackageFile() {
  repoHome=$2
  cd ${repoHome}
  find ./ -name "pom.xml"
}

function package() {
  repoHome=$2
  buildHome=$3
  packgePom=$4
  jarHome=${5/pom.xml/}

  echo "Java Package 目录: ${repoHome}, Package 文件:${packgePom}"

  cd ${repoHome}
  mvn clean install -f ${packgePom}

  mkdir -p "${buildHome}"

  targetPath="${jarHome}target"
  jarFile=$(ls "${targetPath}" | grep ".jar$")
  jarPath=${targetPath}"/"${jarFile}

  echo "jarHome: ${jarHome}, Jar 文件路径: ${jarPath}. 构建路径: ${buildHome}"

  cp "${jarPath}" "${buildHome}"
  cp "/data/build/bin/run_java.sh" "${buildHome}"
  cp /data/build/dockerfile/Dockerfile.jdk8 "${buildHome}"/Dockerfile

   sed -i "s@run_program@runFatJar@g" "${buildHome}/run_java.sh"
   sed -i "s@jarNameParam@${jarFile}@g" "${buildHome}/run_java.sh"
}

$1 $*