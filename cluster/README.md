## Create master node
```
cd k8s/cluster && bash master.sh
```
```
Protocol	Direction	Port Range	Purpose	Used By
TCP	Inbound	6443*	Kubernetes API server	All
TCP	Inbound	2379-2380	etcd server client API	kube-apiserver, etcd
TCP	Inbound	10250	Kubelet API	Self, Control plane
TCP	Inbound	10251	kube-scheduler	Self
TCP	Inbound	10252	kube-controller-manager	Self
```
## Create worker node
```
cd k8s/cluster && bash workerNode.sh
```
```
Protocol	Direction	Port Range	Purpose	Used By
TCP	Inbound	10250	Kubelet API	Self, Control plane
TCP	Inbound	30000-32767	NodePort Services**	All
```
## Run on Master:
  ### Documents
  - https://kubernetes.io/docs/reference/setup-tools/kubeadm/
  ### Set up a master node
  https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
  ```
  kubeadm init [args]
  ```
  ### Install network for communicating among pods
  ```
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  ```
  ### Get the whole command for joining of worker node
  ```
  kubeadm token create --print-join-command
  ```
  ### List all nodes
  ```
  kubectl get nodes
  ```
  ### List all things
  ```
  kubectl get all --all-namespaces
  ```
  ### Remove a node from cluster
  - First drain the node
  ```
  kubectl drain <node-name>
  ```
  - You might have to ignore daemonsets and local-data in the machine
  ```
  kubectl drain <node-name> --ignore-daemonsets --delete-local-data
  ```
  - Finally delete the node
  ```
  kubectl delete node <node-name>
  ```
## Run on Worker:
  ### Open firewall to join to master node
  ```
  iptables -t nat -A OUTPUT -d <Private IP of master node> -j DNAT --to-destination <Public IP of master node>
  ```
  ### References
  - https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join-phase/
