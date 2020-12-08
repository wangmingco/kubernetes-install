#/bin/bash

function config_yum_repo() {
	echo "😊😊😊开始docker设置yum源😊😊😊"

    cd $HOME/kubernetes-install
   
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

	echo "😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊"
}

function create_docker_daemon() {
	echo "😊😊😊创建docker#daemon.json😊😊😊"
   
    cd $HOME/kubernetes-install
   
	mkdir -p /etc/docker
	
	/bin/cp -rf ./daemon.json  /etc/docker/daemon.json
	
	ls -al -h /etc/docker/daemon.json

	echo "😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊"
}

function install_docker() {
    
	echo "😊😊😊开始安装docker😊😊😊"

	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum install -y docker-ce-19.03.14
	systemctl daemon-reload
	systemctl enable docker
	systemctl restart docker
	
    echo "😊😊😊😊😊😊😊😊😊😊😊😊😊😊"
}

config_yum_repo
create_docker_daemon
install_docker
