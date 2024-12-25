# -*- mode: ruby -*-
#kubeadm token create --print-join-command
# vi: set ft=ruby :
NODES_WORKERS = 2
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_check_update = false

  # Kubernetes Master Node
  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    
    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.memory = 2048
      vb.cpus = 2
    end
    
    master.vm.provision "shell", path: "master.sh"
  end

  # Kubernetes Worker Node
  (1..NODES_WORKERS).each do |i|
    config.vm.define "k8s-worker-#{i}" do |worker|
      worker.vm.hostname = "k8s-worker-#{i}"
      worker.vm.network "private_network", ip: "192.168.56.#{i + 10}"
      
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-worker-#{i}"
        vb.memory = 2048
        vb.cpus = 1
      end
      
      worker.vm.provision "shell", path: "worker.sh"
    end
  end
end