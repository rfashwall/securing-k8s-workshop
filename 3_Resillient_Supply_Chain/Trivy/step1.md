#### Installation

- Install Trivy Operator

```bash
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm upgrade --install trivy-operator aqua/trivy-operator \
--namespace trivy-system \
--version 0.25.0 \
--create-namespace \
--set serviceMonitor.enabled=true \
--set trivy.ignoreUnfixed=false 
```{{exec}}

- Check generated reports(might take 2 mins)
```
k get vulnerabilityreports.aquasecurity.github.io -A -owide -w
```{{exec}}

- Create a new deployment, so that it will be scanned by the operator

```
k create deployment nginx --image nginx:alpine --replicas 2
```{{exec}}

- Import this dashboard to Grafana by ID: 16337
