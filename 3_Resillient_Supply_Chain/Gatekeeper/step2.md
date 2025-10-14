This ConstraintTemplate and example Constraint enforce a policy that requires certain labels to be present on specified Kubernetes resources. The Rego policy logic checks for missing labels and generates a violation message if any required labels are absent. The example constraint applies this policy to Namespace resources, requiring them to have the k8s-security label.

1. Create a Constraint Template

```bash
cat 01-required-labels-template.yaml
kubectl apply -f 01-required-labels-template.yaml -n gatekeeper-system
```{{exec}}

2. Create required label constraint for namespaces
```yaml
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

3. Now if we create a namespace without the label, the webhook will fire an error and will fail.

```bash
kubectl create ns no-label
```{{exec}}

4. Create namespace with label
```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: label
  labels:
    k8s-security: shouldwork
spec: {}
EOF
```{{exec}}