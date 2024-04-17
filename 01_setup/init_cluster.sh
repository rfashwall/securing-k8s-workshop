#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "\n*******************************************************************************************************************"
echo "Creating new kind cluster"
echo "*******************************************************************************************************************"
kind create cluster --config "$SCRIPT_DIR"/kind_config.yaml --name securing-k8s-cluster

echo "\n*******************************************************************************************************************"
echo "Installing Calico"
echo "*******************************************************************************************************************"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml

echo "\n*******************************************************************************************************************"
echo "Installing Nginx Ingress Controller"
echo "*******************************************************************************************************************"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "\n*******************************************************************************************************************"
echo "Labeling worker nodes"
echo "*******************************************************************************************************************"
kubectl label node securing-k8s-cluster-worker  ingress-ready=true
kubectl label node securing-k8s-cluster-worker2 ingress-ready=true
