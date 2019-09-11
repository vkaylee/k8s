- Launch scripts for every node
```
sudo locale-gen UTF-8
sudo apt update
sudo apt install git -y
git clone https://github.com/vleedev/k8s.git
bash k8s/docker/docker.sh
sudo usermod -aG docker $USER
sudo reboot
```
# RANCHER (The tool manages k8s)
## Install docker first
- Install
```
sudo locale-gen UTF-8 && sudo apt update && sudo apt install git -y && git clone https://github.com/vleedev/k8s.git && bash k8s/docker/docker.sh
```
- Make normal user can exec docker
```
sudo usermod -aG docker $USER
```
## Single Node Install
```
docker run -d --restart=unless-stopped -p 8889:443 -v /root/ssl/vlee.dev/privkey1.pem:/etc/rancher/ssl/key.pem -v /root/ssl/vlee.dev/fullchain1.pem:/etc/rancher/ssl/cert.pem rancher/rancher:latest --no-cacerts
```
## High Availability (HA) Install
### Create Nodes and Load Balancer
- Make file /etc/nginx.conf
```
sudo nano /etc/nginx.conf
```
```
worker_processes 4;
worker_rlimit_nofile 40000;

events {
    worker_connections 8192;
}

stream {
    upstream rancher_servers_http {
        least_conn;
        server <IP_NODE_1>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:80 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:80 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     80;
        proxy_pass rancher_servers_http;
    }

    upstream rancher_servers_https {
        least_conn;
        server <IP_NODE_1>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_2>:443 max_fails=3 fail_timeout=5s;
        server <IP_NODE_3>:443 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     443;
        proxy_pass rancher_servers_https;
    }
}
```
- Run docker container
```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /etc/nginx.conf:/etc/nginx/nginx.conf nginx:1.16
```
### Install Kubernetes with RKE
- Create the rancher-cluster.yml file
```
nodes:
  - address: 165.227.114.63
    internal_address: 172.16.22.12
    user: ubuntu
    role: [controlplane,worker,etcd]
  - address: 165.227.116.167
    internal_address: 172.16.32.37
    user: ubuntu
    role: [controlplane,worker,etcd]
  - address: 165.227.127.226
    internal_address: 172.16.42.73
    user: ubuntu
    role: [controlplane,worker,etcd]

services:
  etcd:
    snapshot: true
    creation: 6h
    retention: 24h
```
- Download RKE
```
wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64 && chmod 755 rke_linux-amd64
```
- Set up RKE
```
./rke_linux-amd64 up --config ./rancher-cluster.yml
```
- Create the kube_config_rancher-cluster.yml file
```
export KUBECONFIG=$(pwd)/kube_config_rancher-cluster.yml
```
- Install kubectl
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```
- Install helm
```
sudo apt install -y snapd
sudo snap install helm --classic
```
- Create ssh key gen
```
ssh-keygen -t rsa -b 4096 -C "system@vlee.dev" -N
```
