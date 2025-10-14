1. Check the custom rule

```bash
cat falco.yaml
```{{exec}}

2. Upgrade falco with new custom rule and enable UI
```bash
helm upgrade --namespace falco falco falcosecurity/falco -f falco.yaml --set falcosidekick.enabled=true --set falcosidekick.webui.enabled=true

```{{exec}}

3. Access the pod shell
```bash
kubectl exec -it nginx -- sh
```{{exec}}

4. Access Falco Console in a new terminal

```bash
kubectl -n falco port-forward svc/falco-falcosidekick-ui 2802  --address 0.0.0.0
```{{exec}}
