#### Prometheus and Grafana

- Install prometheus and grafana
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.probeSelectorNilUsesHelmValues=false
```{{exec}}


#### Trivy

- Install Trivy Operator
```
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm upgrade --install trivy-operator aqua/trivy-operator \
--namespace trivy-system \
--version 0.21.2 \
--create-namespace \
--set serviceMonitor.enabled=true \
--set trivy.ignoreUnfixed=true
```{{exec}}

The operator will scan all the cluster and do benchmarking for the nodes

- Port forward grafan

- Import this dashboard by ID: 16337