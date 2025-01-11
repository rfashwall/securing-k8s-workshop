- Create a new pod

```
kubectl run nginx --image=nginx:alpine
```{{exec}}

- Access pod shell
```
kubectl wait --for=condition=ready pod nginx
k exec -it pod -- sh # run "exit"
```{{exec}}

- Open a new terminal and run the following command

```bash
cat /var/log/syslog | grep falco | grep shell
```{{exec}}
