# Autok3s

- other: k3sup

```bash
# update sys
>> sudo apt update
>> sudo apt upgrade -y

# install pkgs
>> sudo apt install fish axel aria2 nload tmux mosh

>> mosh-server

>> sudo apt install docker.io
>> sudo gpasswd -a $USER docker

# docker pull
>> docker pull nginxproxy/nginx-proxy
>> docker pull cnrancher/autok3s:v0.4.6

# binary
>> aria2c

>> docker-compose 
>> k3d
>> autok3s

>> kubecm
>> octant
>> vela

>> download.fastgit.org
>> hub.fastgit.xyz
>> chmod +x
>> mv /usr/bin

# k3s
>> docker-compose up -d
>> autok3s -d serve --bind-address 0.0.0.0

# k3s cluster
>> autok3s create -p k3d -n test-k3d \
    --master 1 --worker 2 \
    --k3s-install-script https://get.k3s.io \
    --api-port 0.0.0.0:30888 \
    --image rancher/k3s:v1.21.7-k3s1 \
    --ports '8088:80@loadbalancer' \
    --ports '8443:443@loadbalancer' \
    --ports '30880:30880@loadbalancer'
>> autok3s kubectl config use-context k3d-test-k3d
>> autok3s kubectl get pods -A

# nginx demo
>> autok3s kubectl create deployment nginx --image=nginx
>> autok3s kubectl create service clusterip nginx --tcp=80:80

## helm
>> sudo rm ~/.kube/config
>> autok3s kubectl config view --raw > ~/.kube/config
>> sudo chmod 400 ~/.kube/config
>> helm list
```

## Octant

```bash
>> octant --listener-addr 0.0.0.0:7777
```

## Rancher

```bash
>> docker run -d --privileged \
    --name rancher \
    --restart=unless-stopped \
    -p 8000:80 -p 8443:443 \
    rancher/rancher:latest
```

## Kubevela

```bash
>> vela install
>> vela addon enable velaux serviceType=LoadBalancer repo=acr.kubevela.net
>> autok3s kubectl get service velaux -n vela-system
>> vela port-forward --address 0.0.0.0 -n vela-system addon-velaux 9082:80
```

- first-vela-app: crccheck/hello-world

```bash
>> docker run -d --rm --name web-test -p 30880:8000 crccheck/hello-world
>> autok3s kubectl port-forward --address 0.0.0.0 -n default (autok3s kubectl get pod -n default -o jsonpath='{.items[0].metadata.name}') 30880:8000
```

## KubeSphere

```bash
# kubesphere
>> autok3s kubectl apply -f https://hub.fastgit.xyz/kubesphere/ks-installer/releases/download/v3.2.1/kubesphere-installer.yaml
>> autok3s kubectl apply -f https://hub.fastgit.xyz/kubesphere/ks-installer/releases/download/v3.2.1/cluster-configuration.yaml

## log
>> autok3s kubectl logs -n kubesphere-system (autok3s kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f
## namespace
>> autok3s kubectl get pod --all-namespaces
## port
>> autok3s kubectl get svc/ks-console -n kubesphere-system
## forward
>> autok3s kubectl port-forward --address 0.0.0.0 -n kubesphere-system svc/ks-console 30880:80
```

----
----

- k1s
- k9s
- OpenKruise
- Kuboard
- Kubenav

- k8slens
- nocalhost

----

## Kubeapps

```bash
>> helm repo add bitnami https://charts.bitnami.com/bitnami
>> autok3s kubectl create namespace kubeapps
>> helm install kubeapps --namespace kubeapps bitnami/kubeapps

>> kubectl create --namespace default serviceaccount kubeapps-operator
>> kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator

>> autok3s kubectl port-forward --address 0.0.0.0 -n kubeapps svc/kubeapps 9082:80
```

## Rainbond(failed)

```bash
>> autok3s kubectl create namespace rbd-system
>> helm repo add rainbond https://openchart.goodrain.com/goodrain/rainbond
>> helm install rainbond rainbond/rainbond-cluster -n rbd-system

>> watch autok3s kubectl get po -n rbd-system
>> ...
```
