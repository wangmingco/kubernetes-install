#/bin/bash

function clone_repo() {
    echo "๐๐๐ ๅผๅงไธ่ฝฝไปๅบ ๐๐๐"
	command -v git >/dev/null 2>&1 || { yum install -y git; }

    rm -rf $HOME/kubernetes-install/
	git clone https://gitee.com/wangmingco/kubernetes-install.git ~/kubernetes-install/

    echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

function install_master() {
    echo "๐๐๐ kubeadm ๅผๅงๅฎ่ฃmaster ๐๐๐"
    kubeadm reset -f
    rm -rf /etc/cni/net.d
    rm -rf $HOME/.kube/config
    
    # echo "็ๆ kubeadm.default.yaml ๆไปถ"
    # kubeadm config print init-defaults > ./kubeadm.default.yaml
	# sed -i "s@imageRepository: k8s.gcr.io@imageRepository: registry.aliyuncs.com/google_containers@g" ./kubeadm.default.yaml
	
    localIp=`ifconfig eth0|grep -w 'inet'|awk '{ print $2}'`
    sed -i "s@advertiseAddress: 1.2.3.4@advertiseAddress: ${localIp}@g" ./kubeadm.config.yaml
    publicIp=`curl ip.cip.cc`
    sed -i "s@0.0.0.1@${publicIp}@g" ./kubeadm.config.yaml

    echo "ๅฎ่ฃ kubernetes master"
	kubeadm init --config=kubeadm.config.yaml

    errorCpu=`cat $HOME/install_kubernetes_master.log | grep "ERROR NumCPU"`
    if [ "$errorCpu" != "" ]
    then
        echo "ๅฎ่ฃ kubernetes masterๅคฑ่ดฅ๏ผCPUๆกไปถไธ็ฌฆๅ๏ผ่ทณ่ฟๆฃๆฅ๏ผๅๅฐ่ฏไธๆฌก"
        kubeadm init --config=kubeadm.config.yaml --ignore-preflight-errors=all
    fi

    echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

function set_config() { 
    echo "๐๐๐ ๅผๅง้็ฝฎๆๆไฟกๆฏ็ฎๅฝ ๐๐๐"

    # kubectl ้ป่ฎคไผไฝฟ็จ $HOME/.kube ็ฎๅฝไธ็ๆๆไฟกๆฏ่ฎฟ้ฎ Kubernetes ้็พค
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

function call_on_finished() { 
    
    echo "๐๐๐ ๅผๅงๆๅๆฃๆฅๅทฅไฝ ๐๐๐"

    echo "ๅ ้คmaster-nodeไธ็ๆฑก็น้็ฝฎ"
    sleep 10s
    kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-
    
    kubectl create namespace demo
    kubectl apply -f ./pods/demo.yaml

    print_plugin

    echo "ๆฅ็ๆๆnamespaceไธ็Pod"
    for variable  in {1..300}
	do
    	kubectl get pods --all-namespaces
		sleep 1s
	done
    echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
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
	    $arg | tee $HOME/${arg}.log
	done
else     
	call_all | tee $HOME/install_kubernetes_master.log
fi