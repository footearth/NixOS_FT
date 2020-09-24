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
```

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
     --cert ~/.kube/cert/kubecfg.crt \
     --cert-key ~/.kube/cert/kubecfg.key \
     https://0.0.0.0:36679/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ \
     | jq | bat

>> rsync -avz $username@$host_ip:~/kind/cert/kubeconf.p12 ./
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

## 参考资料

- https://istio.io/v1.5/zh/docs/setup/platform-setup/kind/
- https://www.cnblogs.com/rainingnight/p/deploying-k8s-dashboard-ui.html
- https://blog.miniasp.com/post/2020/08/21/Install-Kubernetes-cluster-in-WSL-2-Docker-on-Windows-using-kind
- https://juejin.im/post/6844903807562989582
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/zhangguanzhang/google_containers
- http://reborncodinglife.com/2019/06/10/install-istio-via-kind/
