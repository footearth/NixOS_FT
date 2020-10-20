# k3d

- https://github.com/rancher/k3d

```bash
>> k3d cluster create meolove --k3s-server-arg "--disable=servicelb" --k3s-server-arg "--disable=traefik" --update-kubeconfig --no-lb --network=host
>> k3d cluster create meolove --api-port 6443 -p 30008:30008 --k3s-server-arg "--disable=servicelb" --k3s-server-arg "--disable=traefik" --no-lb
>> k3d cluster delete meolove
```
