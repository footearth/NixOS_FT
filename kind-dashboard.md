# kind and dashboard

## kind

### kind.yaml

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "0.0.0.0"
nodes:
  - role: control-plane
    image: kindest/node:v1.19.1
    extraMounts:
    - hostPath: /var/run/docker.sock
      containerPath: /var/run/docker.sock
    extraPortMappings:
    - containerPort: 8080
      hostPort: 8080
    - containerPort: 8000
      hostPort: 8000
    - containerPort: 3000
      hostPort: 3000
      # - containerPort: 6443
      # hostPort: 6443
    - containerPort: 32567 # kuboard
      hostPort: 32567
      # optional: set the bind address on the host
      # 0.0.0.0 is the current default
      # listenAddress: "127.0.0.1"
      # optional: set the protocol to one of TCP, UDP, SCTP.
      # TCP is the default
      # protocol: TCP
```

## kube tools

- k9s
- k1s
- octant
- vela

### create cluster

```bash
>> kind create cluster --name moelove --config kind.yaml
```

## kubernetes-dashboard

```bash
>> kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
>> kubectl get pod -n kubernetes-dashboard

# >> kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
# >> export token=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 -d)
# >> echo $token

>> kubectl proxy --address="0.0.0.0" --accept-hosts='^*$'
```

### cert

```bash
#!/usr/bin/env bash

# 生成client-certificate-data
grep 'client-certificate-data' ~/.kube/config \
  | head -n 1 | awk '{print $2}' | base64 -d \
  >> kubecfg.crt

# 生成client-key-data
grep 'client-key-data' ~/.kube/config \
  | head -n 1 | awk '{print $2}' | base64 -d \
  >> kubecfg.key

# 生成p12
openssl pkcs12 -export -clcerts \
  -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 \
  -name "kubernetes-client"
```

```bash
>> http --verify=no \
     --cert ./kubecfg.crt \
     --cert-key ./kubecfg.key \
     https://0.0.0.0:6443/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ \
     | jq | bat

>> rsync -avz $username@$host_ip:~/kind/kubeconf.p12 ./
>> pk12util -i ./kubecfg.p12 -d sql:$HOME/.pki/nssdb -W ''
```

### creating-sample-user

- https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

```bash
>> cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

>> cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

>> kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

## octant

```bash
# https://github.com/vmware-tanzu/octant/releases
>> aria $octant_tar_gz
>> tar xvf $octant_tar_gz
>> octant --listener-addr 0.0.0.0:7777 --disable-open-browser
```

## Kuboard

```bash
# https://kuboard.cn/install/install-dashboard.html
>> kubectl apply -f https://kuboard.cn/install-script/kuboard-beta.yaml
>> kubectl get pods -l k8s.kuboard.cn/name=kuboard -n kube-system
# http://${ip}:32567
>> echo $(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d)
```

## kela

```bash
# https://github.com/oam-dev/kubevela/releases
>> aria $kela_tar_gz
>> tar xvf $kela_tar_gz
>> vela install
>> vela dashboard
```

## Rainbond

```bash
## Rainbond Operator
>> kubectl create ns rbd-system
>> helm repo add rainbond https://openchart.goodrain.com/goodrain/rainbond
>> helm install rainbond-operator rainbond/rainbond-operator \
     --namespace rbd-system
>> kubectl get pod -n rbd-system
## Rainbond
```

## 参考资料

- https://istio.io/v1.5/zh/docs/setup/platform-setup/kind/
- https://www.cnblogs.com/rainingnight/p/deploying-k8s-dashboard-ui.html
- https://blog.miniasp.com/post/2020/08/21/Install-Kubernetes-cluster-in-WSL-2-Docker-on-Windows-using-kind
- https://juejin.im/post/6844903807562989582
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/zhangguanzhang/google_containers
- http://reborncodinglife.com/2019/06/10/install-istio-via-kind/
