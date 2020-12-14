#!/bin/bash

function set_client_alive() {
	echo "" >> /etc/ssh/sshd_config
	echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 720" >> /etc/ssh/sshd_config

	cat /etc/ssh/sshd_config | grep "ClientAlive"

	systemctl restart sshd	
}

set_client_alive