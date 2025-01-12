Gatekeeper is an open-source project developed by the Kubernetes community. It is a policy enforcement tool that helps ensure that Kubernetes workloads adhere to a set of predefined policies or constraints. These policies could cover security, compliance, resource allocation, and other operational requirements.

##### Install Gatekeeper

```bash
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
```{{exec}}
