# RANCHER (The tool manages k8s)
## Install docker first
```
locale-gen UTF-8 && apt update && apt install git -y && git clone https://github.com/vleedev/k8s.git && bash k8s/docker/docker.sh
```
## Single Node Install
```
docker run -d --restart=unless-stopped -p 8889:443 -v /root/ssl/vlee.dev/privkey1.pem:/etc/rancher/ssl/key.pem -v /root/ssl/vlee.dev/fullchain1.pem:/etc/rancher/ssl/cert.pem rancher/rancher:latest --no-cacerts
```
## High Availability (HA) Install
### Create Nodes and Load Balancer
- Make file /etc/nginx.conf
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
