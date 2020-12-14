#/bin/bash

function install_net_plugin() { 
    echo "🤗️🤗️🤗️ 安装 weave 网络插件 🤗️🤗️🤗️"
    kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

    echo "🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️"
}

function install_dashboard_plugin() { 

    echo "🤗️🤗️🤗️ 安装 dashboard 插件 🤗️🤗️🤗️"
    kubectl apply -f https://kuboard.cn/install-script/kuboard.yaml
    kubectl apply -f https://addons.kuboard.cn/metrics-server/0.3.7/metrics-server.yaml

    kubectl get pods -l k8s.kuboard.cn/name=kuboard -n kube-system

    echo "🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️"
}

function install_storge_plugin() { 
    echo "🤗️🤗️🤗️ 安装 ceph 存储插件 🤗️🤗️🤗️"
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/common.yaml
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/operator.yaml
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/cluster.yaml
    kubectl get pods -n rook-ceph

    echo "🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️"
}

function print_plugin() {
    echo "🤗️🤗️🤗️ Api访问请使用如下配置(~/.kube/config) 🤗️🤗️🤗️"
    cat ~/.kube/config
    echo "🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️"

    echo "🤗️🤗️🤗️ Dashboard️️️️请访问 🤗️🤗️🤗️"
    echo "IP:  http://${publicIp}:32567"
    echo "token: "
    echo $(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d)
    echo "🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️🤗️"
}
    
install_net_plugin
install_storge_plugin
install_dashboard_plugin