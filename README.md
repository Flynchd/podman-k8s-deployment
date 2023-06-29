# podman_k8s_3master-3worker


This bash script is designed to setup a Kubernetes cluster across multiple CentOS 9 hosts. It first updates all the hosts, installs Docker and Podman, enables Docker, and then installs and starts Kubernetes. Once Kubernetes is set up on the master node, it uses kubeadm to join the worker nodes to the cluster, completing the creation of the Kubernetes cluster.
