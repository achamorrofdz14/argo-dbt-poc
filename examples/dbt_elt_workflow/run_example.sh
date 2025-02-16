#!/bin/bash

## Create dockerfile
IMAGE_NAME="dbt-postgres-image:latest"

cp ./dbt_project/scripts/Dockerfile ./Dockerfile

docker build -t $IMAGE_NAME .

kind load docker-image $IMAGE_NAME -n multi-node-cluster

rm ./Dockerfile

argo submit -n argo ./argo_workflows/main_dbt_workflow.yaml