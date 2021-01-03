#!/bin/bash

yum remove -y docker-ce-19.03.14

kubectl delete node --all

for service in kube-apiserver kube-controller-manager kubectl kubelet kube-proxy kube-scheduler; do
  systemctl stop $service
done

kubeadm -y reset -f

yum remove -y kubelet-1.19.4 kubeadm-1.19.4 kubectl-1.19.4

rm -rf /etc/docker/
rm -rf /etc/kubernetes/
rm -rf /var/lib/etcd/
rm -rf /etc/cni/net.d
rm -rf $HOME/.kube/