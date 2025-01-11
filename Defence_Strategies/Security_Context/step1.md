
#### Pod Without Security Context
This file defines a pod without any security context settings.


```bash
kubectl apply -f insecure-pod.yaml 
```{{exec}}

Access the pod's shell and check the security risk.

```bash
kubectl exec -it insecure-pod -n development -- sh
```{{exec}}


You will likely see that the process is running as the root user (`uid=0`), which can be exploited by malicious users to perform unauthorized actions.

#### Pod With Security Context

- `runAsUser`: Specifies the user ID to run the container process.
- `runAsGroup`: Specifies the primary group ID for the container process.
- `fsGroup`: Specifies the group ID for volumes mounted by the pod.
- `allowPrivilegeEscalation`: Prevents the container from gaining more privileges than its parent process.

```bash
kubectl apply -f secure-pod.yaml
```{{exec}}
Access the secure pod's shell and verify the security context settings.

```bash
kubectl exec -it secure-pod -n development -- sh
```{{exec}}

Inside the pod, check the user ID:

```sh
id
```{{exec}}
