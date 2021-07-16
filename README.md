# kubernetes-install

#### 介绍
Kubernetes  + Docker 自动安装脚本

#### 说明
一键自动安装Docker和Kubernetes。整个安装流程如下：
1. 在home目录下创建kubernetes-install文件夹，并在该文件夹下检出当前仓库
2. 安装Docker软件并启动 (Docker 社区 19.03.14 版本)
3. 安装Kubernetes软件 (kubelet,kubeadm和kubectl 这三个的1.19.4版本)
4. 启动Kubernetes Master 节点
5. 安装Kubernetes 插件 (weave, ceph 和 kuboard。)

全部组件安装完成后，apiserver和kuboard 都可以进行公网访问，访问方式在安装后的控制台日志中有说明。

安装脚本是在腾讯云的1核2G的云主机上进行测试的。

#### 安装教程


使用Docker和Kuberneters快速部署应用(使用Java示范)

操作主机[ 腾讯云服务器 1C/2G CentOS-7 ]

1. 手动上传 Harbor 离线安装包到Home目录下
```
harbor-offline-installer-v2.1.2.tgz
```
2. 安装Docker和Kuberneters, 执行下面命令:
```
sh -c "$(curl -fsSL https://gitee.com/wangmingco/kubernetes-install/raw/master/install_kubernetes_master.sh)" 2>&1 | tee  ${HOME}/install_kubernetes_master.log
```
3. 安装harbor, 执行下面命令:
```
sh ~/kubernetes-install/install_harbor.sh | tee  ${HOME}/install_harbor.log
```
4. 访问kuboard
```
http://公网IP:32567/login
```
5. 访问harbor
```
http://公网IP:10080/harbor/
```
6. 安装Kube-Cloud-Server, 执行下面命令(先设置mysql密码 root/root):
```
mysql_secure_installationl
sh ~/kubernetes-install/install_kube_cloud_server.sh
```
7. 访问 kube_cloud 部署Java应用
```
http://公网IP:10080/harbor/
```
