# RANCHER (The tool manages k8s)
## Single Node Install
```
docker run -d --restart=unless-stopped -p 8889:443 -v /root/ssl/vlee.dev/privkey1.pem:/etc/rancher/ssl/key.pem -v /root/ssl/vlee.dev/fullchain1.pem:/etc/rancher/ssl/cert.pem rancher/rancher:latest --no-cacerts
```
## High Availability (HA) Install
### Create Nodes and Load Balancer
#### Install Nginx ( Run in normal user )
```
sudo apt install -y curl gnupg2 ca-certificates lsb-release \
echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list \
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
apt-key fingerprint ABF5BD827BD9BF62 \
apt update \
apt install -y nginx
```
