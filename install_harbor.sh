#!/bin/bash

function install_pip() {
  echo "🙃️🙃️🙃️ 安装依赖软件  🙃️🙃️🙃️"
  yum -y install jq

  yum -y install epel-release
  yum -y install python-pip
  pip install --upgrade pip

  rm -rf /usr/lib/python2.7/site-packages/requests-2.6.0-py2.7.egg-info

  echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️"
}

function install_docker_compose() {
  echo "🙃️🙃️🙃️ 安装docker compose 🙃️🙃️🙃️"
  # 安装失败 参考 https://www.cnblogs.com/felixqiang/p/11946644.html
  pip install docker-compose==1.26.2
  echo "docker-compose 版本："
  docker-compose --version

  echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️"
}

function install_harbor() {
  echo "🙃️🙃️🙃️ 安装harbor 🙃️🙃️🙃️"
  cd $HOME/
  rm -rf ./harbor
  tar -zxvf ./${file_exist}
  cd harbor
  cp harbor.yml.tmpl harbor.yml
  sed -i "s@reg.mydomain.com@${publicIp}@g" ./harbor.yml
  sed -i "s@port: 80@port: 10080@g" ./harbor.yml
  sed -i "s@https:@# https:@g" ./harbor.yml
  sed -i "s@port: 443@# port: 443@g" ./harbor.yml
  sed -i "s@certificate: /your/certificate/path@# certificate: /your/certificate/path@g" ./harbor.yml
  sed -i "s@private_key: /your/private/key/path@# private_key: /your/private/key/path@g" ./harbor.yml

  sh ./prepare
  sh ./install.sh
  echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️"
}

function add_to_daemon_json() {
  echo "🙃️🙃️🙃️ 修改daemon.json文件 🙃️🙃️🙃️"
  cd /etc/docker/
  jq '.insecureregistries=[ "http://0.0.0.0:10080" ]' daemon.json >daemon.json.bak
  sed -i "s@insecureregistries@insecure-registries@g" daemon.json.bak >>daemon.json.bak
  sed -i "s@0.0.0.0@${publicIp}@g" daemon.json.bak >>daemon.json.bak
  rm -rf ./daemon.json
  cp daemon.json.bak daemon.json

  echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️"
}

function start() {
  source ./common.sh
  install_pip
  install_docker_compose
  install_harbor
  add_to_daemon_json
}

file_exist=$(ls $HOME | grep 'harbor-offline-installer')
if [[ -n "${file_exist}" ]]; then
  echo "🙃️🙃️🙃️ Harbor安装程序开始 🙃️🙃️🙃️"
  cd $HOME/kubernetes-install
  start
  echo "安装harbor完成"
  echo "请在浏览器访问: http://${publicIp}:10080/harbor"
  echo "请在命令后访问: docker login -u admin -p Harbor12345 http://${publicIp}:10080"

  echo "执行仓库测试命令"
  echo "拉取最新centos: docker pull vish/stress"
  docker pull vish/stress
  echo "列出本地镜像: docker images"
  docker images
  echo "centos镜像打标签: docker tag vish/stress ${publicIp}:10080/library/vish/stress:2020"
  docker tag vish/stress ${publicIp}:10080/library/vish/stress:2020
  echo "推送镜像到harbor仓库: docker push ${publicIp}:10080/library/vish/stress:2020"
  docker push ${publicIp}:10080/library/vish/stress:2020
  echo "退出登录: docker logout"
  docker logout

  echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃🙃️🙃️🙃️🙃️"
fi
