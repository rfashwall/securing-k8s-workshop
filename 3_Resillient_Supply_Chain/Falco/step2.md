Falco comes with a pre-installed set of rules that alert you upon suspicious behavior.

1. Trigger a rule by creating a deployment:

```bash
kubectl create deployment nginx --image=nginx
```{{exec}}

2. Execute a command that would trigger a rule:

```bash
kubectl exec -it $(kubectl get pods --selector=app=nginx -o name) -- cat /etc/shadow
```{{exec}}

3. Check Falco logs:

```bash
kubectl logs -l app.kubernetes.io/name=falco -n falco -c falco | grep Warning
```{{exec}}
