This ConstraintTemplate and example Constraint enforce a policy that requires certain labels to be present on specified Kubernetes resources. The Rego policy logic checks for missing labels and generates a violation message if any required labels are absent. The example constraint applies this policy to Namespace resources, requiring them to have the k8s-security label.

```bash
kubectl apply -f 01-required-labels-template.yaml -n gatekeeper-system
```{{exec}}

Create required label constraint
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

Now if we create a namespace without the label, the webhook will fire an error and will fail.
