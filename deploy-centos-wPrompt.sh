#!/bin/bash

# Prompt for user input
read -p "Enter the name of the deployment: " deployment_name
read -p "Enter the Docker image to use: " docker_image

# define a Kubernetes deployment with a CentOS pod
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${deployment_name}
  labels:
    app: ${deployment_name}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${deployment_name}
  template:
    metadata:
      labels:
        app: ${deployment_name}
    spec:
      containers:
      - name: ${deployment_name}
        image: ${docker_image}
        ports:
        - containerPort: 80
EOF
