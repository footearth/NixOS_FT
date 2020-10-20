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
