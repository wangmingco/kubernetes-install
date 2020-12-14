#!/bin/bash

function set_client_alive() {
	echo "😘😘😘 设置Linux保持连接不超时  😘😘😘"

	sed -i "s@#ClientAliveInterval 0@ClientAliveInterval 120@g" /etc/ssh/sshd_config
	sed -i "s@#ClientAliveCountMax 3@ClientAliveCountMax 720@g" /etc/ssh/sshd_config

	cat /etc/ssh/sshd_config | grep "ClientAlive"

	systemctl restart sshd	
	echo "😘😘😘😘😘😘😘😘😘😘😘😘😘😘😘"
}

function set_publicip() {
	echo "😘😘😘 开始获取公网IP  😘😘😘"
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

	echo "😘😘😘😘😘😘😘😘😘😘😘😘😘😘😘"
}

set_client_alive
set_publicip