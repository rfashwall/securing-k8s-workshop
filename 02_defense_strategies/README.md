
# Defense Strategies
```
cd 02_defense_strategies
```
## Network Policy

Kubernetes Network Policies act as firewalls within your Kubernetes cluster. They provide a way to control and secure the network traffic flow between pods and services.

**Demo**
For the demo, we have 2 pods with a simple setup where we have a web server (my-server) and a client (my-client) that periodically checks if the server can be reached. The Service provides an internal network endpoint to make communication between the Pods possible.

- Start by creating the pods using config `01-setup.yaml`
	```
	kubectl apply -f 01-setup.yaml
	```
- Check the logs
	```
	kubectl logs my-client --tail=15 -f
	```
- Create deny all policy
	```
	kubectl apply -f 02-default-network-policy.yaml
	```
Now the requests will fail since the policy block all the traffic
- Create the network policy for the server
	```
	kubectl apply -f 03-allow-network-policy.yaml
	```
Then the requests will be successfull again

## TLS Termination
1.  **Generate a Self-Signed Certificate**
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key \
-out tls.crt -subj "/CN=my-service.np-demo.svc"
```
- This creates `tls.key` (private key), and `tls.crt` (certificate).

-  **Important:** For production, use a proper certificate authority like Let's Encrypt.

```
kubectl create secret tls my-service-tls-secret \
--cert=tls.crt --key=tls.key \
--namespace=np-demo
```

2.  **Create an Ingress Resource**
	`kubectl apply -f 05-tls-ingress.yaml -n np-demo`

**Explanation**
- We generate a simple self-signed certificate
- The secret stores the certificate and private key
- The Ingress:
	- References the secret for TLS termination.
	- Routes traffic for the hostname `my-service.svc` to `my-service`.

## RBAC

### Overly Permissive Roles
1. **Creating Required Resources for RBAC :**
   To set up the necessary resources for the demo, execute the following command. It will create a Service Account and bind it to a broad role.
    ```
    kubectl apply -f 06-rbac-exploit-access.yaml
    ```
2. **Generating Token and CA Certificate:**
   To generate the token and CA certificate required for testing commands, use the following commands:
    ```
    TOKEN=$(kubectl -n development get secret pod-developer-token -o jsonpath='{.data.token}' | base64 --decode)
    kubectl get secret pod-developer-token -n development -o jsonpath="{.data['ca\.crt']}" | base64 -d > ca.crt
    ```
3. **Getting API Server Address:**
   Retrieve the API server address by executing the command below. The output will provide the necessary server address.
    ```
    kubectl cluster-info
    ```
   Output Example:
    ```
    Kubernetes control plane is running at https://127.0.0.1:54237
    CoreDNS is running at https://127.0.0.1:54237/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```

   Trim the address using the command:
    ```
    export APISERVER=$(kubectl cluster-info | grep -o 'https://[0-9\.]*:[0-9]*' | awk 'NR==1{print}')
    ```

4. **Testing Attacker's Privilege:**
   To check if the attacker has full privileges, execute the following cURL command:
    ```
    curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d '{"apiVersion":"v1","kind":"Pod","metadata":{"name":"nginx-pod"},"spec":{"containers":[{"name":"nginx","image":"nginx"}]}}' \
    ${APISERVER}/api/v1/namespaces/default/pods --cacert ca.crt
    ```

   Upon successful execution, you will receive the JSON response indicating the creation of the pod.

### Least Privilege RBAC

1. **Creating Required Resources for RBAC :**
   To set up the necessary resources for the demo, execute the following command. It will create a Service Account and bind it to a broad role.
    ```
    kubectl apply -f 07-rbac-limited-access.yaml
    ```
2. **Generating Token and CA Certificate:**
   To generate the token and CA certificate required for testing commands, use the following commands:
    ```
    READER_TOKEN=$(kubectl -n development get secret pod-reader-token -o jsonpath='{.data.token}' | base64 --decode)
    kubectl get secret pod-reader-token -n development -o jsonpath="{.data['ca\.crt']}" | base64 -d > readerca.crt
    ```

3. **Testing Pod reader with high Privilege:**
   - To check if the attacker has full privileges, execute the following cURL command:
    ```
    curl -X POST -H "Authorization: Bearer $READER_TOKEN" -H "Content-Type: application/json" \
    -d '{"apiVersion":"v1","kind":"Pod","metadata":{"name":"nginx-pod"},"spec":{"containers":[{"name":"nginx","image":"nginx"}]}}' \
    ${APISERVER}/api/v1/namespaces/default/pods --cacert readerca.crt
    ```

   You will receive the JSON response indicating Forbidden request
   - Try listing the pods in `default` namespace:
   ```
   curl -H "Authorization: Bearer $READER_TOKEN" ${APISERVER}/api/v1/namespaces/default/pods --cacert readerca.crt
   ```
   It will also fail 
   - Try listing the pods in `development` namespace:
   ```
   curl -H "Authorization: Bearer $READER_TOKEN" ${APISERVER}/api/v1/namespaces/development/pods --cacert readerca.crt
   ```
   This will list all the pods in the `development` namespace successfully 

## References
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [nginx-ingress](https://docs.nginx.com/nginx-ingress-controller/)
- [Calico](https://docs.tigera.io/calico/latest/about/)
