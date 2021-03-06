#/bin/bash

function install_net_plugin() { 
    echo "ð¤ï¸ð¤ï¸ð¤ï¸ å®è£ weave ç½ç»æä»¶ ð¤ï¸ð¤ï¸ð¤ï¸"
    kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

    echo "ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸"
}

function install_dashboard_plugin() { 

    echo "ð¤ï¸ð¤ï¸ð¤ï¸ å®è£ dashboard æä»¶ ð¤ï¸ð¤ï¸ð¤ï¸"
    kubectl apply -f https://kuboard.cn/install-script/kuboard.yaml
    kubectl apply -f https://addons.kuboard.cn/metrics-server/0.3.7/metrics-server.yaml

    kubectl get pods -l k8s.kuboard.cn/name=kuboard -n kube-system

    echo "ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸"
}

function install_storge_plugin() { 
    echo "ð¤ï¸ð¤ï¸ð¤ï¸ å®è£ ceph å­å¨æä»¶ ð¤ï¸ð¤ï¸ð¤ï¸"
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/common.yaml
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/operator.yaml
    kubectl apply -f https://gitee.com/wangmingco/rook/raw/master/cluster/examples/kubernetes/ceph/cluster.yaml
    kubectl get pods -n rook-ceph

    echo "ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸"
}

function print_plugin() {
    echo "ð¤ï¸ð¤ï¸ð¤ï¸ Apiè®¿é®è¯·ä½¿ç¨å¦ä¸éç½®(~/.kube/config) ð¤ï¸ð¤ï¸ð¤ï¸"
    cat ~/.kube/config
    echo "ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸"

    echo "ð¤ï¸ð¤ï¸ð¤ï¸ Dashboardï¸ï¸ï¸ï¸è¯·è®¿é® ð¤ï¸ð¤ï¸ð¤ï¸"
    publicIp=`curl ip.cip.cc`
    echo "IP:  http://${publicIp}:32567"
    echo "token: "
    echo $(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d)
    echo "ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸ð¤ï¸"
}
    
install_net_plugin
install_storge_plugin
install_dashboard_plugin