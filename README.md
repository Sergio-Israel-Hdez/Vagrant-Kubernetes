# Kubernetes Cluster Setup with Vagrant and Shell Scripts

## Overview
This project provides a simple way to deploy a Kubernetes cluster with one master node and multiple worker nodes using Vagrant and shell scripts. It automates the installation of Docker, Kubernetes components (kubelet, kubeadm, kubectl), and the Calico network plugin for container communication.

---

## English

### Vagrant Configuration

The `Vagrantfile` defines the virtual machine setup for both the master and worker nodes:
- The master node (`k8s-master`) is configured with 2GB of memory and 2 CPUs.
- Each worker node (`k8s-worker-N`) is configured with 2GB of memory and 1 CPU.
- All nodes are connected to a private network with static IPs.

### Master Node Setup (`master.sh`)

The `master.sh` script provisions the Kubernetes master node:
1. Updates and installs the necessary prerequisites (Docker, Kubernetes).
2. Installs Docker and sets up the vagrant user to have access.
3. Installs Kubernetes and configures it using `kubeadm init`.
4. Deploys Calico for networking.
5. Configures `kubectl` for the vagrant user to interact with the cluster.

### Worker Node Setup (`worker.sh`)

The `worker.sh` script provisions the worker nodes:
1. Updates and installs the necessary prerequisites (Docker, Kubernetes).
2. Installs Docker and configures the vagrant user.
3. Installs Kubernetes and configures it to join the master node using `kubeadm join`.
4. Configures `containerd` and restarts all necessary services.

---

## Español

### Configuración de Vagrant

El `Vagrantfile` define la configuración de las máquinas virtuales tanto para el nodo maestro como para los nodos trabajadores:
- El nodo maestro (`k8s-master`) está configurado con 2 GB de memoria y 2 CPUs.
- Cada nodo trabajador (`k8s-worker-N`) está configurado con 2 GB de memoria y 1 CPU.
- Todos los nodos están conectados a una red privada con IPs estáticas.

### Configuración del Nodo Maestro (`master.sh`)

El script `master.sh` prepara el nodo maestro de Kubernetes:
1. Actualiza e instala los prerequisitos necesarios (Docker, Kubernetes).
2. Instala Docker y configura al usuario vagrant para que tenga acceso.
3. Instala Kubernetes y lo configura usando `kubeadm init`.
4. Despliega Calico para la red.
5. Configura `kubectl` para que el usuario vagrant pueda interactuar con el clúster.

### Configuración de los Nodos Trabajadores (`worker.sh`)

El script `worker.sh` prepara los nodos trabajadores:
1. Actualiza e instala los prerequisitos necesarios (Docker, Kubernetes).
2. Instala Docker y configura al usuario vagrant.
3. Instala Kubernetes y lo configura para unirse al nodo maestro mediante `kubeadm join`.
4. Configura `containerd` y reinicia todos los servicios necesarios.

---

### Requirements
- **VirtualBox**: A hypervisor to run the virtual machines.
- **Vagrant**: To manage the virtual machine setup.
- **Ubuntu**: The operating system for the virtual machines (Ubuntu 20.04 Focal Fossa).

### Usage
1. Clone the repository.
2. Navigate to the project folder.
3. Run `vagrant up` to start the virtual machines.
4. After the provisioning process completes, you can interact with the Kubernetes cluster using `kubectl`.
