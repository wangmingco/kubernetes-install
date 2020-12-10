#/bin/bash

function clone_repo() {
    echo "😈😈😈 开始下载仓库 😈😈😈"
	command -v git >/dev/null 2>&1 || { yum install -y git; }
	
    rm -rf $HOME/kubernetes-install 

	git clone https://gitee.com/wangmingco/kubernetes-install.git ~/kubernetes-install/

    echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function install_master() {
    echo "😈😈😈 kubeadm 开始安装master 😈😈😈"
    kubeadm reset -f
    rm -rf /etc/cni/net.d
    rm -rf $HOME/.kube/config
    
    # echo "生成 kubeadm.default.yaml 文件"
    # kubeadm config print init-defaults > ./kubeadm.default.yaml
	# sed -i "s@imageRepository: k8s.gcr.io@imageRepository: registry.aliyuncs.com/google_containers@g" ./kubeadm.default.yaml
	
    localIp=`ifconfig eth0|grep -w 'inet'|awk '{ print $2}'`
    sed -i "s@advertiseAddress: 1.2.3.4@advertiseAddress: ${localIp}@g" ./kubeadm.config.yaml
    publicIp=`curl ip.cip.cc`
    sed -i "s@0.0.0.1@${publicIp}@g" ./kubeadm.config.yaml

    echo "安装 kubernetes master"
	kubeadm init --config=kubeadm.config.yaml

    errorCpu=`cat $HOME/install_kubernetes_master.log | grep "ERROR NumCPU"`
    if [ "$errorCpu" != "" ]
    then
        echo "安装 kubernetes master失败，CPU条件不符合，跳过检查，再尝试一次"
        kubeadm init --config=kubeadm.config.yaml --ignore-preflight-errors=all
    fi

    echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function set_config() { 
    echo "😈😈😈 开始配置授权信息目录 😈😈😈"

    # kubectl 默认会使用 $HOME/.kube 目录下的授权信息访问 Kubernetes 集群
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
    
    kubectl create namespace demo
    kubectl apply -f ./pods/demo.yaml

    print_plugin

    echo "查看所有namespace下的Pod"
    watch -n 1 kubectl get pods --all-namespaces

    echo "😈😈😈😈😈😈😈😈😈😈😈😈😈😈😈"
}

function call_all() {
    cd $HOME
    clone_repo
    
    cd $HOME/kubernetes-install

	source ./install_docker.sh
    source ./install_kubernetes.sh
	install_master
    set_config

    source ./install_plugins.sh

    call_on_finished
}

if [ $# -gt 0 ] 
then
	for arg in $*; do
	    $arg | tee  $HOME/{$arg}.log
	done
else     
	call_all | tee  $HOME/install_kubernetes_master.log
fi
