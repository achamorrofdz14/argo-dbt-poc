#!/bin/bash

# Script to set up PostgreSQL inside a kind cluster with Argo Workflows.

set -e

# --- 1. Check for Kind and Kubectl ---

if ! command -v kind &> /dev/null; then
  echo "Error: kind is not installed. Please install kind before running this script."
  exit 1
fi

if ! command -v kubectl &> /dev/null; then
  echo "Error: kubectl is not installed. Please install kubectl before running this script."
  exit 1
fi

# --- 3. Deploy PostgreSQL using Helm ---

if ! command -v helm &> /dev/null; then
  echo "Helm is not installed.  Installing Helm..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
fi

# Add the Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install PostgreSQL.
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF

helm install postgresql bitnami/postgresql \
  --namespace default \
  --set global.storageClass="" \
  --set persistence.existingClaim=postgres-pvc \
  --set primary.persistence.enabled=true \
  --set primary.persistence.size=2Gi \
  --set auth.postgresPassword=mysecretpassword \
  --set volumePermissions.enabled=true

echo "Waiting for PostgreSQL to be ready..."
kubectl wait --namespace default --for=condition=ready pod --selector=app.kubernetes.io/name=postgresql --timeout=300s

# Create a pod to run psql
kubectl run -it --rm --namespace default postgresql-client --image=postgres:latest --restart=Never -- bash

# --- 5. Provide Connection Information ---

echo "PostgreSQL is ready!"
echo "  Service Name: postgresql"
echo "  Namespace: default"
echo "  Username: postgres"
echo "  Password: mysecretpassword"
echo "  Database: postgres"
echo "  Port: 5432"
echo ""
echo "To access PostgreSQL from outside the cluster (e.g., from your host machine), you'll need to use port-forwarding:"
echo "  kubectl port-forward -n default svc/postgresql 5432:5432"
echo ""
echo "You can now set the following environment variables for the Argo workflow:"
echo "  export POSTGRES_HOST=postgresql"
echo "  export POSTGRES_PORT=5432"
echo "  export POSTGRES_USER=postgres"
echo "  export POSTGRES_PASSWORD=mysecretpassword"
echo "  export POSTGRES_DB=postgres"
echo "Remember to use Kubernetes Secrets for production deployments!"
