#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 

# Update and install prerequisites
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gpg

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-cache policy docker-ce
apt-get install docker-ce -y

# Add vagrant user to the Docker group
usermod -aG docker vagrant

# Enable and restart Docker service
echo "[TASK 3] Restart Docker service"
systemctl restart docker
systemctl status docker

# Disable swap
echo "[TASK 4] Disable SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install Kubernetes
echo "[TASK 5] Install Kubernetes"
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet

# Containerd configuration
echo "[TASK 6] Configure containerd"
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd
apt-get install -y conntrack

# Restarting services
echo "[TASK 7] Restarting services"
systemctl restart containerd
systemctl restart kubelet
systemctl restart docker

# Initialize Kubernetes Cluster
echo "[TASK 8] Initialize Kubernetes Cluster"
kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --apiserver-advertise-address=192.168.56.10

# Copy Kube admin config to the vagrant user's home directory
echo "[TASK 9] Configure kubectl for vagrant user"
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy Calico network
echo "[TASK 10] Deploy Calico network"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml"

# Open required Kubernetes API port
ufw allow 6443


# echo "[TASK 11] Install metallb"
# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
# mkdir metallb-config
# cd metallb-config
# echo "apiVersion: metallb.io/v1beta1
# kind: IPAddressPool
# metadata:
#   name: my-pool
#   namespace: metallb-system
# spec:
#   addresses:
#     - 192.168.56.100-192.168.56.200  # Ajusta el rango según disponibilidad
# ---
# apiVersion: metallb.io/v1beta1
# kind: L2Advertisement
# metadata:
#   name: my-advertisement
#   namespace: metallb-system
# " >> metallb-config.yaml
# kubectl apply -f metallb-config.yaml


# echo "[TASK 12] Token create"
# kubeadm token create --print-join-command
# de momento se tiene que ejecutar el comando de forma manual en el main y en el worker resultado como sudo 
