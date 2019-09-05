- bash k8s/cluster/master.sh
- bash k8s/cluster/workernode.sh
- Run on Master:
  - KK
- Run on Worker:
  - Open firewall to join to master node
  ```
  iptables -t nat -A OUTPUT -d <Private IP of master node> -j DNAT --to-destination <Public IP of master node>
  ```
