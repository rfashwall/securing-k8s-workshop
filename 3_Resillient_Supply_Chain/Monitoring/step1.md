#### Prometheus and Grafana

##### Install prometheus and grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.probeSelectorNilUsesHelmValues=false
```{{exec}}

##### Expose Port

```bash
k port-forward services/prometheus-grafana -n monitoring 8090:80 --address 0.0.0.0
```{{exec}}

##### Get User & Password

```
kubectl get secret prometheus-grafana -n monitoring -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
```{{exec}}
