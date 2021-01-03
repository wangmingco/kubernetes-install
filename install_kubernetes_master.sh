#!/bin/bash

function clone_repo() {
  echo "😈😈😈 开始下载仓库 😈😈😈"
  command -v git >/dev/null 2>&1 || { yum install -y git; }

  git clone https://gitee.com/wangmingco/kubernetes-install.git ~/kubernetes-install/

  echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function install_master() {
  echo "😈😈😈 kubeadm 开始安装master 😈😈😈"
  # kubeadm reset -f
  rm -rf /etc/cni/net.d
  rm -rf $HOME/.kube/config

  # echo "生成 kubeadm.default.yaml 文件"
  # kubeadm config print init-defaults > ./kubeadm.default.yaml
  # sed -i "s@imageRepository: k8s.gcr.io@imageRepository: registry.aliyuncs.com/google_containers@g" ./kubeadm.default.yaml

  sed -i "s@advertiseAddress: 1.2.3.4@advertiseAddress: ${localIp}@g" ./kubeadm.config.yaml
  sed -i "s@0.0.0.1@${publicIp}@g" ./kubeadm.config.yaml

  echo "安装 kubernetes master"
  kubeadm init --config=kubeadm.config.yaml

  errorCpu=$(cat $HOME/install_kubernetes_master.log | grep "ERROR NumCPU")
  if [ "$errorCpu" != "" ]; then
    echo "安装 kubernetes master失败，CPU条件不符合，跳过检查，再尝试一次"
    kubeadm init --config=kubeadm.config.yaml --ignore-preflight-errors=all
  fi

  echo "测试镜像拉取"
  kubeadm config images pull --config=kubeadm.config.yaml

  echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function set_kube_config() {
  echo "😈😈😈 开始配置授权信息目录 😈😈😈"

  # kubectl 默认会使用 $HOME/.kube 目录下的授权信息访问 Kubernetes 集群
  rm -rf $HOME/.kube
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function call_on_finished() {

  echo "😈😈😈 开始最后检查工作 😈😈😈"

  echo "删除master-node上的污点配置"
  sleep 10s
  kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-

  sh $HOME/kubernetes-install/build/bin/init.sh
  kubectl create namespace demo
  kubectl apply -f ./pods/demo.yaml

  print_plugin

  echo "查看所有namespace下的Pod"
  for variable in {1..300}; do
    clear
    kubectl get pods --all-namespaces
    sleep 1s
  done

  echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function call_all() {
  cd $HOME
  rm -rf $HOME/kubernetes-install
  clone_repo
  cd $HOME/kubernetes-install

  source ./common.sh
  source ./install_dev_dependency.sh
  source ./install_docker.sh
  source ./install_kubernetes.sh
  install_master
  set_kube_config

  source ./install_kubernetes_plugins.sh

  call_on_finished
}

if [ $# -gt 0 ]; then
  for arg in $*; do
    $arg
  done
else
  call_all
fi
