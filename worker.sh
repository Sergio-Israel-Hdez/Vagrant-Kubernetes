#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y

apt-cache policy docker-ce
apt-get install docker-ce -y

# # add ccount to the docker group
usermod -aG docker vagrant

# Enable docker service
echo "[TASK 3] Restart docker service"
systemctl restart docker
systemctl status docker

# Disable swap
echo "[TASK 4] Disable SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Installing Kubernetes
echo "[TASK 5] Kubernetes"
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet

# Containerd configuration
echo "[TASK 6] containerd configuration"
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd
apt-get install -y conntrack

# Restarting services
echo "[TASK 7] restarting services"
systemctl restart containerd
systemctl restart kubelet
systemctl restart docker


echo "[TASK 8] Join Kubernetes Cluster"
echo "$1"
if [ -f /vagrant/join-command.sh ]; then
  bash /vagrant/join-command.sh
else
  echo "[TASK 8] Join command not found"
fi