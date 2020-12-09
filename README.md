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

直接在命令行中执行
```
sh -c "$(curl -fsSL https://gitee.com/wangmingco/kubernetes-install/raw/master/install_kubernetes_master.sh)" 2>&1 | tee  ./install_kubernetes_master.log
```
