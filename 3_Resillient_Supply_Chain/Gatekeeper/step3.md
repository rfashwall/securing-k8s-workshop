This setup ensures that any newly created Pods must use container images from the specified allowed registries. If a Pod attempts to use an image from an unlisted registry, it will be denied admission to the cluster, helping to maintain security and compliance by restricting image sources to trusted registries.

- Create a Constraint Template that enforce our custom registry
```bash
cat 02-enforce-registries.yaml
kubectl apply -f 02-enforce-registries.yaml -n gatekeeper-system
```{{exec}}

- Create required label constraint

```yaml
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
      - "docker.io/library"

EOF
```{{exec}}

- Try running pod with invalid registry

```bash
kubectl run i-will-fail --image docker.io/bitnamilegacy/mongo
```{{exec}}

- This will run 
```bash
kubectl run i-will-run --image docker.io/library/hello-world
```{{exec}}

- Clean
```bash
kubectl delete K8sAllowedRepository/allow-only-private-repository -n gatekeeper-system
kubectl delete po i-will-run
```{{exec}}
