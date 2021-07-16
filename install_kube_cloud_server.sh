#!/bin/bash

function clone_kube_cloud_server() {
        git clone https://gitee.com/wangmingco/kube-cloud-server.git ~/kube-cloud-server
}

function package_server() {
        cd ~/kube-cloud-server
        mvn clean package
}

function init_database() {
        mysql -uroot -proot < ~/kube-cloud-server/doc/sql/db.sql
}

function start_server() {
        nohup java -jar ./target/kube-cloud-server-0.1.jar >kube-cloud-server-nohup.log 2>&1 &
        jps -l | grep "kube-cloud-server" | awk '{print $1}' > server.pid
        echo "运行中的Java程序"
        jps -l
}

clone_kube_cloud_server
package_server
init_database
start_server
