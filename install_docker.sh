#/bin/bash

function config_yum_repo() {
	echo "๐๐๐ๅผๅงdocker่ฎพ็ฝฎyumๆบ๐๐๐"

    cd $HOME/kubernetes-install
   
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

	echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

function create_docker_daemon() {
	echo "๐๐๐ๅๅปบdocker#daemon.json๐๐๐"
   
    cd $HOME/kubernetes-install
   
	mkdir -p /etc/docker
	
	/bin/cp -rf ./daemon.json  /etc/docker/daemon.json
	
	ls -al -h /etc/docker/daemon.json

	echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

function install_docker() {
    
	echo "๐๐๐ๅผๅงๅฎ่ฃdocker๐๐๐"

	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum install -y docker-ce-19.03.14
	systemctl daemon-reload
	systemctl enable docker
	systemctl restart docker
	
    echo "๐๐๐๐๐๐๐๐๐๐๐๐๐๐"
}

config_yum_repo
create_docker_daemon
install_docker
