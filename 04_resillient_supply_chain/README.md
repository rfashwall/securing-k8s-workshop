# Resillient Supply Chain

```
cd 04_resillient_supply_chain
```

## Gatekeeper

Gatekeeper is an open-source project developed by the Kubernetes community. It is a policy enforcement tool that helps ensure that Kubernetes workloads adhere to a set of predefined policies or constraints. These policies could cover security, compliance, resource allocation, and other operational requirements.

* **Install Chart**
```
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
```
* **Our first Constarint template**
```
kubectl apply -f 01-required-labels-template.yaml -n gatekeeper-system
```

Create required label constraint
```
cat <<EOF | kubectl apply -f -
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: ns-must-have-label
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Namespace"]
  parameters:
    labels: ["k8s-security"]
EOF
```

Now if we create a namespace without the label, the webhook will fire an error and will fail.

* **Example 2: Allow only specific Repos**
```
kubectl apply -f 02-enforce-registries.yaml -n gatekeeper-system
```

Create required label constraint
```
cat <<EOF | kubectl apply -f -
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedRepository
metadata:
  name: allow-only-private-repository
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
  parameters:
    registries:
      - "k8s-security.docker.com"

EOF
```

This will enforce only the included repo in the above rule

* ***Example 3: Enforce resources**
```
kubectl apply -f 03-required-resources.yaml -n gatekeeper-system
```

Create enforce resource constraint
```
cat <<EOF | kubectl apply -f -
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: k8sRequiredResources
metadata:
  name: should-include-resources
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
EOF
```

This will enforce the created pods to include resources(limits and requests)

- Clean
```
kubectl delete K8sRequiredLabels/ns-must-have-label -n gatekeeper-system
kubectl delete k8sRequiredResources/should-include-resources -n gatekeeper-system
kubectl delete K8sAllowedRepository/allow-only-private-repository -n gatekeeper-system
```

## Trivy 

**Prometheus and Grafana**
- Install prometheus and grafana
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.probeSelectorNilUsesHelmValues=false
```


**Trivy**
- Install Trivy Operator
```
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm upgrade --install trivy-operator aqua/trivy-operator \
--namespace trivy-system \
--version 0.21.2 \
--create-namespace \
--set serviceMonitor.enabled=true \
--set trivy.ignoreUnfixed=true
```

The operator will scan all the cluster and do benchmarking for the nodes

- Port forward grafan

- Import this dashboard by ID: 16337

## Falco
```
helm repo add falcosecurity https://falcosecurity.github.io/charts
 helm upgrade --install falco -n falco  \
 --set falcosidekick.enabled=true \
 --set driver.kind=modern-bpf \
 --set tty=true \
 --set  falco.grpc_output.enabled=true \
 --set falcosidekick.enabled=true --create-namespace falcosecurity/falco
```


## References
- [Trivy Operator](https://github.com/aquasecurity/trivy-operator)
- [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeperr)
- [Falco](https://falco.org/docs)
