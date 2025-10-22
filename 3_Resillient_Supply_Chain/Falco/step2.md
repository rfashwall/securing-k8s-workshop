Falco comes with a pre-installed set of rules that alert you upon suspicious behavior.

- Trigger a rule by creating a deployment:

```bash
kubectl run nginx --image=nginx
```{{exec}}

- Execute a command that would trigger a rule:

```bash
kubectl exec -it nginx -- cat /etc/shadow
```{{exec}}

- Check Falco logs:

```bash
kubectl logs -l app.kubernetes.io/name=falco -n falco -c falco | grep Warning
```{{exec}}
