#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Install basic dependencies
echo "Installing basic dependencies..."
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker
echo "Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# Install K3S
echo "Installing K3S..."
curl -sfL https://get.k3s.io | sh -

# Install OpenTofu (using the official script)
echo "Installing OpenTofu..."
curl -fsSL https://opentofu.org/install.sh | bash

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectl using Snap
echo "Installing kubectl..."
sudo snap install kubectl --classic

# Install Python 3.x
echo "Installing Python 3.x..."
sudo apt-get install -y python3

# Verify installations
echo "Verifying installations..."
docker --version
k3s --version
tofu --version
helm version
kubectl version --client
python3 --version

echo "All tools have been installed successfully!"