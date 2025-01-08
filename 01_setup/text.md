```bash
kind create cluster --name securing-k8s-cluster --config kind-config.yaml
```
This creates a kind cluster named "securing-k8s-cluster". The `kind-config.yaml` file allows customization of your cluster's configuration if needed.

- Setup Networking: 
The default kind networking is disabled since some features we need to test doesn't work. After the cluster is ready, we insatll `calico` 
```
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm install calico projectcalico/tigera-operator -n kube-system
```
