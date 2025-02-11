#!/bin/bash

ARGO_WORKFLOWS_VERSION="v3.5.14"

### Create cluster with kind
kind create cluster --name=multi-node-cluster --config=kind-config

### Install argo inside a namespace
kubectl create namespace argo
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"


### Installing Argo CLI

# Detect OS
ARGO_OS="darwin"
if [[ "$(uname -s)" != "Darwin" ]]; then
  ARGO_OS="linux"
fi

# Download the binary
curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/v3.5.14/argo-$ARGO_OS-amd64.gz"

# Unzip
gunzip "argo-$ARGO_OS-amd64.gz"

# Make binary executable
chmod +x "argo-$ARGO_OS-amd64"

# Move binary to path
mv "./argo-$ARGO_OS-amd64" /usr/local/bin/argo

# Test installation
argo version

# Inlcude pv and pvc to store artifacts
kubectl -n argo apply -f ./pv-pvc.yml

### Install UI
kubectl -n argo port-forward service/argo-server 2746:2746