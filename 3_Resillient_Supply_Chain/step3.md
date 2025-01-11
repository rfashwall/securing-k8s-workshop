#### Falco

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm upgrade --install falco -n falco  \
--set falcosidekick.enabled=true \
--set driver.kind=modern-bpf \
--set tty=true \
--set  falco.grpc_output.enabled=true \
--set falcosidekick.enabled=true --create-namespace falcosecurity/falco
```{{exec}}
