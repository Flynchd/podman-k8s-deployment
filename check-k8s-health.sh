#!/bin/bash

# Check if kubelet service is running
kubelet_status=$(systemctl is-active kubelet)
if [ "$kubelet_status" = "active" ]; then
    echo "Kubernetes is running smoothly."
else
    echo "Kubernetes is not running."
fi

# Check if podman service is running
podman_status=$(systemctl is-active podman)
if [ "$podman_status" = "active" ]; then
    echo "Podman is running smoothly."
else
    echo "Podman is not running."
fi
