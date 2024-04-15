# Securing Kubernetes : Practical Workflows and Tools for Enhanced Cluster Protection

## Setting Up Your Kubernetes Demo Environment
### Prerequisites

 **Script:** Run the script `install_tools.sh` (provided in the repo). This script automates the installation of the following required tools:
* kubectl
* kind
* helm
* docker
* git

**Supported Operating Systems:** The script and instructions are designed for macOS and Ubuntu Linux.

### Starting K8s cluster
For setup simplicity, we will use the two popular tools for creating local Kubernetes clusters: kind and minikube. 
> For the demos, kind is recommended.

**1. Starting a Kubernetes Cluster with kind**

*  **Command:**

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

* **Or use the included script**
```
./init_cluster.sh
```

### Applications

Below are useful applications that will help you with the demo
**1.Cluster Viewer**
- [Kubelens](https://k8slens.dev/) to have visual view for k8s cluster
- [k9s](https://k9scli.io/topics/install/) a terminal based UI to interact with your Kubernetes clusters
- for gurus, just use `kubectl` :)
**2.IDE**
I use [VSCode](https://code.visualstudio.com/), of course you can use any prefered IDE

### References
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
