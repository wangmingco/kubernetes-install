#!/bin/bash

function config_firewall() {
  echo "😺😺😺 开始设置防火墙 😺😺😺"

  cd $HOME/kubernetes-install

  systemctl disable firewalld
  systemctl stop firewalld

  setenforce 0

  cp /etc/selinux/config /etc/selinux/config.bak
  sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

  # 设置iptables
  cp -rf ./k8s.conf /etc/sysctl.d/k8s.conf
  sysctl --system

  # 允许网卡间数据转发
  echo 1 >/proc/sys/net/ipv4/ip_forward

  echo "打印 /etc/selinux/config 配置"
  cat /etc/selinux/config

  echo "打印 /proc/sys/net/ipv4/ip_forward 配置"
  cat /proc/sys/net/ipv4/ip_forward

  echo "😺😺😺😺😺😺😺😺😺😺😺😺😺😺😺"
}

function config_swap() {
  echo "😺😺😺 开始设置交换区 😺😺😺"

  cd $HOME/kubernetes-install

  swapoff -a

  sed -i "s@/dev/mapper/centos-swap@#/dev/mapper/centos-swap@g" /etc/fstab

  echo "打印 /etc/fstab 配置"
  cat /etc/fstab

  free -m
  echo "😺😺😺😺😺😺😺😺😺😺😺😺😺😺"
}

function create_kubernetes_repo() {
  cd $HOME/kubernetes-install

  /bin/cp -rf ./kubernetes.repo /etc/yum.repos.d/kubernetes.repo

  echo "打印 /etc/yum.repos.d/kubernetes.repo 配置"
  cat /etc/yum.repos.d/kubernetes.repo
}

function install_kubernetes() {

  echo "😺😺😺 开始安装kubernetes 😺😺😺"

  cd $HOME/kubernetes-install

  echo "创建 kubernetes.repo 文件"
  create_kubernetes_repo

  echo "安装 kubelet， kubeadm， kubectl"
  yum install -y kubelet-1.19.4 kubeadm-1.19.4 kubectl-1.19.4 --disableexcludes=kubernetes

  echo "启动 kubelet"
  systemctl enable kubelet
  systemctl restart kubelet

  echo "😺😺😺😺😺😺😺😺😺😺😺😺😺😺😺😺😺😺"
}

config_firewall
config_swap
config_yum_repo
install_kubernetes
