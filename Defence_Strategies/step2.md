## TLS Termination

### Generate a Self-Signed Certificate

```plain
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key \
-out tls.crt -subj "/CN=my-service.np-demo.svc"
```{{exec}}

- This creates `tls.key` (private key), and `tls.crt` (certificate).

-  **Important:** For production, use a proper certificate authority like Let's Encrypt.

```plain
kubectl create secret tls my-service-tls-secret \
--cert=tls.crt --key=tls.key \
--namespace=np-demo
```{{exec}}

### Create an Ingress Resource

	```plain
      kubectl apply -f 05-tls-ingress.yaml -n np-demo
   ```{{exec}}

### Explanation

- We generate a simple self-signed certificate
- The secret stores the certificate and private key
- The Ingress:
	- References the secret for TLS termination.
	- Routes traffic for the hostname `my-service.svc` to `my-service`.

## References
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [nginx-ingress](https://docs.nginx.com/nginx-ingress-controller/)
- [Calico](https://docs.tigera.io/calico/latest/about/)
