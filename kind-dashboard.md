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
>> kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
>> export token=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 -d)
>> echo $token
>> kubectl proxy --address="0.0.0.0" --accept-hosts='^*$'
```

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
     https://0.0.0.0:32768/api/v1/namespaces/kubernetes-dashboard/services/kubernetes-dashboard \
     | jq | bat

>> rsync -avz $username@$host_ip:~/.kube/cert ./
>> pk12util -i ./kubecfg.p12 -d sql:$HOME/.pki/nssdb -W ''
```

## 参考资料

- https://istio.io/v1.5/zh/docs/setup/platform-setup/kind/
- https://www.cnblogs.com/rainingnight/p/deploying-k8s-dashboard-ui.html
- https://blog.miniasp.com/post/2020/08/21/Install-Kubernetes-cluster-in-WSL-2-Docker-on-Windows-using-kind
- https://juejin.im/post/6844903807562989582
- https://kind.sigs.k8s.io/docs/user/configuration/
- https://github.com/zhangguanzhang/google_containers
- http://reborncodinglife.com/2019/06/10/install-istio-via-kind/
