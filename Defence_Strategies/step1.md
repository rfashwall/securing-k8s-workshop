## Network Policy

Kubernetes Network Policies act as firewalls within your Kubernetes cluster. They provide a way to control and secure the network traffic flow between pods and services.

**Demo**
For the demo, we have 2 pods with a simple setup where we have a web server (my-server) and a client (my-client) that periodically checks if the server can be reached. The Service provides an internal network endpoint to make communication between the Pods possible.

- Start by creating the pods using config `01-setup.yaml`

	```plain
	   kubectl apply -f 01-setup.yaml
	```{{exec}}

- Check the logs

	```plain
	   kubectl logs my-client --tail=15 -f -n np-demo
	```{{exec}}

- Create deny all policy

	```plain
	   kubectl apply -f 02-default-network-policy.yaml
	```{{exec}}

- Check the logs

	```plain
	   kubectl logs my-client --tail=15 -f -n np-demo
	```{{exec}}

Now the requests will fail since the policy block all the traffic
- Create the network policy for the server

	```plain
	   kubectl apply -f 03-allow-network-policy.yaml
	```{{exec}}

Then the requests will be successfull again
