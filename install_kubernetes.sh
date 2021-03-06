#/bin/bash

function config_firewall() {
	echo "ðºðºðº å¼å§è®¾ç½®é²ç«å¢ ðºðºðº"
	
    cd $HOME/kubernetes-install

    systemctl disable firewalld
	systemctl stop firewalld

	setenforce 0

	sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

    # è®¾ç½®iptables
    cp ./k8s.conf /etc/sysctl.d/k8s.conf
    sysctl --system

    # åè®¸ç½å¡é´æ°æ®è½¬å
    echo 1 > /proc/sys/net/ipv4/ip_forward
    
    echo "æå° /etc/selinux/config éç½®"
    cat /etc/selinux/config

    echo "æå° /proc/sys/net/ipv4/ip_forward éç½®"
    cat /proc/sys/net/ipv4/ip_forward

	echo "ðºðºðºðºðºðºðºðºðºðºðºðºðºðºðº"
}

function config_swap() {
	echo "ðºðºðº å¼å§è®¾ç½®äº¤æ¢åº ðºðºðº"
    
    cd $HOME/kubernetes-install
   
	swapoff -a
	
    sed -i "s@/dev/mapper/centos-swap@#/dev/mapper/centos-swap@g"  /etc/fstab

    echo "æå° /etc/fstab éç½®"
    cat /etc/fstab

    free -m
	echo "ðºðºðºðºðºðºðºðºðºðºðºðºðºðº"
}

function create_kubernetes_repo() {
    cd $HOME/kubernetes-install
   
	/bin/cp -rf ./kubernetes.repo /etc/yum.repos.d/kubernetes.repo
	
    echo "æå° /etc/yum.repos.d/kubernetes.repo éç½®"
    cat /etc/yum.repos.d/kubernetes.repo
}

function install_kubernetes() {

	echo "ðºðºðº å¼å§å®è£kubernetes ðºðºðº"
	
    cd $HOME/kubernetes-install
   
	echo "åå»º kubernetes.repo æä»¶"
	create_kubernetes_repo
	
	echo "å®è£ kubeletï¼ kubeadmï¼ kubectl"
	yum install -y kubelet-1.19.4 kubeadm-1.19.4 kubectl-1.19.4 --disableexcludes=kubernetes

	echo "æµè¯éåæå"
	kubeadm config images pull --config=kubeadm.default.yaml
	
	echo "å¯å¨ kubelet"
	systemctl enable kubelet
	systemctl restart kubelet
	
	echo "ðºðºðºðºðºðºðºðºðºðºðºðºðºðºðºðºðºðº"
}

config_firewall
config_swap
config_yum_repo
install_kubernetes
