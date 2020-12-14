#!/bin/bash

function set_client_alive() {
	echo "" >> /etc/ssh/sshd_config
	echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 720" >> /etc/ssh/sshd_config

	cat /etc/ssh/sshd_config | grep "ClientAlive"

	systemctl restart sshd	
}

function set_publicip() {
	echo "🙃️🙃️🙃️ 开始获取公网IP  🙃️🙃️🙃️"
	publicIp=`curl ip.cip.cc`
	for variable  in {1..10}
	do 
        if [[ ! -n "${publicIp}" ]]; then
			echo "获取公网IP失败，继续重试: "${publicIp}
			sleep 1s
			publicIp=`curl ip.cip.cc`
			continue
		fi
		break
	done
	echo "获取公网IP: "${publicIp}

	echo "🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️🙃️"
}

set_client_alive
set_publicip