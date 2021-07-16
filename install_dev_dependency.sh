#!/bin/bash

function install_maven() {

  wget https://mirrors.bfsu.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
  unzip apache-maven-3.6.3-bin.zip
  sudo mv apache-maven-3.6.3 /opt
  sudo chown -R root:root /opt/apache-maven-3.6.3
  sudo ln -s /opt/apache-maven-3.6.3 /opt/apache-maven

  echo "" >/etc/profile.d/maven.sh
  echo "export M2_HOME=/opt/apache-maven" >>/etc/profile.d/maven.sh
  echo "export PATH=\$PATH:\$M2_HOME/bin" >>/etc/profile.d/maven.sh

  \cp -rf ~/kubernetes-install/build/maven/settings.xml /opt/apache-maven/conf/settings.xml
  source /etc/profile.d/maven.sh
}

function install_mariadb() {

  touch /etc/yum.repos.d/MariaDB.repo

  echo "[mariadb]" > /etc/yum.repos.d/MariaDB.repo
  echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
  echo "baseurl = http://mirrors.ustc.edu.cn/mariadb/yum/10.3/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
  echo "gpgkey=https://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
  echo "gpgcheck=0" >> /etc/yum.repos.d/MariaDB.repo

  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum -y install  MariaDB-server MariaDB-client
  
  systemctl start mariadb
  systemctl enable mariadb
  
  echo "请使用 mysql_secure_installation 命令设置密码"
}

function install_jdk() {
  yum install -y java-1.8.0-openjdk-devel.x86_64
}

function install_golang() {
  rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
  curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
  yum install -y golang
}

function check_on_finished() {
  echo "😎😎😎 JDK 版本 😎😎😎"
  java -version
  echo "😎😎😎 MAVEN 版本 😎😎😎"
  mvn -version
  echo "😎😎😎 mariadb 版本 😎😎😎"
  mysql -V
  echo "😎😎😎 golang 版本 😎😎😎"
  go version
}

mkdir -p $HOME/kubernetes-install/dev_install
cd $HOME/kubernetes-install/dev_install

install_jdk
install_maven
install_mariadb
install_golang
check_on_finished

cd $HOME/kubernetes-install/