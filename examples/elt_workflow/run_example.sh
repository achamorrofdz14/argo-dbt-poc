#!/bin/bash


## CREATE DOCKER IMAGE TO TRANSFORM
IMAGE_NAME="transform-image:latest"

cp ./scripts/transform/Dockerfile ./Dockerfile

docker build -t $IMAGE_NAME .

kind load docker-image $IMAGE_NAME -n multi-node-cluster

rm ./Dockerfile

kubectl apply -f ./workflows/extract/extract.yaml -n argo
kubectl -n argo apply -f ./workflows/load/load.yaml
kubectl -n argo apply -f ./workflows/transform/transform.yaml

argo submit ./workflows/main_elt_workflow.yaml -n argo --watch