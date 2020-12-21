#!/bin/bash

jarName=jarNameParam
mainClass=mainClassParam

params() {
  javaParams=""
}

# 适用于 maven-compiler-plugin, maven-jar-plugin, maven-shade-plugin(NoMainClass),maven-assembly-plugin 打出来的包
runJar() {
  files=$(ls | grep "${jarName}")
  if [ -n "$files" ]; then
    java ${javaParams} -cp ./${jarName}:./lib/ ${mainClass}
  else
    java ${javaParams} -cp ./lib/ ${mainClass}
  fi
}

# 适用于 maven-shade-plugin, spring-boot-maven-plugin,maven-assembly-plugin
runFatJar() {
  java ${javaParams} -jar ./${jarName}
}

runWar() {
  echo "run_war not implement"
}

runZip() {
  echo "run_zip not implement"
}

run_program
