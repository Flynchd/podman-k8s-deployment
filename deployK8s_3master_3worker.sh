#!/bin/bash

# Hosts setup
master=host1
workers=(host2 host3 host4)
username="username"
total_steps=5

echo "Progress:"

# Update all hosts
echo "[20%] - Stage 1: Updating all hosts"
for host in $master ${workers[@]}; do
  ssh ${username}@${host} "sudo dnf -y update"
done

# Install podman and docker on all hosts
echo "[40%] - Stage 2: Installing podman and docker on all hosts"
for host in $master ${workers[@]}; do
  ssh ${username}@${host} "sudo dnf -y install podman docker"
done

# Enable and start docker on all hosts
echo "[60%] - Stage 3: Enabling and starting docker on all hosts"
for host in $master ${workers[@]}; do
  ssh ${username}@${host} "sudo systemctl enable --now docker"
done

# Kubernetes installation
echo "[80%] - Stage 4: Installing and starting Kubernetes"
## Install kubeadm, kubelet and kubectl on all hosts
for host in $master ${workers[@]}; do
  ssh ${username}@${host} "sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes"
  ssh ${username}@${host} "sudo systemctl enable --now kubelet"
done

## Initialize Kubernetes on the master
ssh ${username}@${master} "sudo kubeadm init --pod-network-cidr=10.244.0.0/16"

## Setup local kubeconfig
ssh ${username}@${master} "mkdir -p $HOME/.kube"
ssh ${username}@${master} "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config"
ssh ${username}@${master} "sudo chown $(id -u):$(id -g) $HOME/.kube/config"

## Apply Flannel CNI
ssh ${username}@${master} "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

# Join worker nodes to the cluster
echo "[100%] - Stage 5: Joining worker nodes to the cluster"
joinCommand=$(ssh ${username}@${master} "kubeadm token create --print-join-command")
for worker in ${workers[@]}; do
  ssh ${username}@${worker} "sudo ${joinCommand}"
done

echo "Script completed successfully!"
