## Clone this git
```
git clone https://github.com/vleedev/k8s.git
```
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
  - https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
  ```
  kubeadm init [args]
  ```
  ```
  kubeadm init --pod-network-cidr=192.168.0.0/16
  ```
  ### Install network for communicating among pods (Choose only one)
  #### Install a Pod Network (Weave) https://www.weave.works/blog/weave-net-kubernetes-integration/
  - Open ports on master node and worker nodes TCP 6783 AND UDP 6783/6784
  ```
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  ```
  #### Install a Pod Network (Calico) https://docs.projectcalico.org/v3.5/getting-started/kubernetes/
  ```
  kubectl apply -f https://docs.projectcalico.org/v3.5/getting-started/kubernetes/installation/hosted/etcd.yaml
  kubectl apply -f https://docs.projectcalico.org/v3.5/getting-started/kubernetes/installation/hosted/calico.yaml
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
  ```
  kubectl delete node <node-name>
  ```
  ### View cluster resources
  ```
  kubectl top node
  ```
  ### Install dashboard
  - Docs: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
  ```
  kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'
  ```
  - Create an admin account called k8s-admin
  ```
  kubectl --namespace kube-system create serviceaccount k8s-admin
  kubectl create clusterrolebinding k8s-admin --serviceaccount=kube-system:k8s-admin --clusterrole=cluster-admin
  ```
  - Get the authentication token you need to connect to the dashboard:
  ```
  kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep k8s-admin | awk '{print $1}')
  ```
  - Access it:
  http://masterIP:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
## Run on Worker:
  ### Open firewall to join to master node
  ```
  iptables -t nat -A OUTPUT -d <Private IP of master node> -j DNAT --to-destination <Public IP of master node>
  ```
  ### References
  - https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join-phase/
