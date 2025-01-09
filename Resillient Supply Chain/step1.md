#### Gatekeeper

Gatekeeper is an open-source project developed by the Kubernetes community. It is a policy enforcement tool that helps ensure that Kubernetes workloads adhere to a set of predefined policies or constraints. These policies could cover security, compliance, resource allocation, and other operational requirements.

##### Install Chart

```plain
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
```{{exec}}

##### Our first Constarint template

```plain
kubectl apply -f 01-required-labels-template.yaml -n gatekeeper-system
```{{exec}}

Create required label constraint
```plain
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
```{{exec}}

Now if we create a namespace without the label, the webhook will fire an error and will fail.

##### Example 2: Allow only specific Repos

```
kubectl apply -f 02-enforce-registries.yaml -n gatekeeper-system
```{{exec}}

Create required label constraint

```plain
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
```{{exec}}

This will enforce only the included repo in the above rule

##### Example 3: Enforce resources
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
```{{exec}}

This will enforce the created pods to include resources(limits and requests)

- Clean
```plain
kubectl delete K8sRequiredLabels/ns-must-have-label -n gatekeeper-system
kubectl delete k8sRequiredResources/should-include-resources -n gatekeeper-system
kubectl delete K8sAllowedRepository/allow-only-private-repository -n gatekeeper-system
```{{exec}}
