# RANCHER (The tool manages k8s)
## Install
```
docker run -d --restart=unless-stopped -p 8889:443 -v /root/ssl/vlee.dev/privkey1.pem:/etc/rancher/ssl/key.pem -v /root/ssl/vlee.dev/fullchain1.pem:/etc/rancher/ssl/cert.pem rancher/rancher:latest --no-cacerts
```