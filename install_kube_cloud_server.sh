
function clone-kube-cloud-server() {
    git clone https://gitee.com/wangmingco/kube-cloud-server.git ~/kube-cloud-server
}

function package-server() {
    cd ~/kube-cloud-server
    mvn clean package
}

function init-database() {
    mysql -uroot -proot < ~/kube-cloud-server/doc/sql/db.sql
}

function start-server() {
    nohup java -jar ./target/kube-cloud-server-0.1.jar >kube-cloud-server-nohup.log 2>&1 &

    jps -l | grep "kube-cloud-server" | awk '{print $1}' > server.pid
}

clone-kube-cloud-server
package-server
init-database
start-server
