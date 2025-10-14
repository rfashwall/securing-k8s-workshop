This setup ensures that any newly created Pods must include resource specifications, such as CPU and memory limits and requests. If a Pod does not specify these resources, it will be denied admission to the cluster, helping to manage resource allocation and prevent resource exhaustion.

1. Create a Constraint Template that enforce resources
```bash
cat 03-required-resources.yaml
kubectl apply -f 03-required-resources.yaml -n gatekeeper-system
```{{exec}}


2. Create enforce resource constraint

```yaml
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

3. Run pod without resource limits

```bash
kubectl run nginx --image nginx
```{{exec}}

4. Run pod with resource limits

```bash
cat 04-pod-with-resources.yaml
kubectl apply -f 04-pod-with-resources.yaml
```{{exec}}

5. Clean
```bash
kubectl delete K8sRequiredLabels/ns-must-have-label -n gatekeeper-system
kubectl delete k8sRequiredResources/should-include-resources -n gatekeeper-system
kubectl delete K8sAllowedRepository/allow-only-private-repository -n gatekeeper-system
```{{exec}}
