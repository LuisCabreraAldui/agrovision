#!/bin/bash

# Script to install or update all required tools.
# Compatible with Ubuntu.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install or update a tool
install_or_update() {
    local tool_name=$1
    local install_command=$2
    local update_command=$3

    if command_exists "$tool_name"; then
        echo "$tool_name is already installed."
        if [ -n "$update_command" ]; then
            echo "Updating $tool_name..."
            eval "$update_command"
        else
            echo "No update command provided for $tool_name. Skipping update."
        fi
    else
        echo "Installing $tool_name..."
        eval "$install_command"
    fi
}

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker
install_or_update "docker" "sudo apt install -y docker.io" "sudo apt install --only-upgrade -y docker.io"
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo "Docker installed/updated successfully."

# Install K3S
if command_exists "k3s"; then
    echo "K3S is already installed."
else
    echo "Installing K3S..."
    curl -sfL https://get.k3s.io | sh -
    echo "K3S installed successfully."
fi

# Install OpenTofu
install_or_update "tofu" \
    "wget https://github.com/opentofu/opentofu/releases/download/v1.9.0/tofu_1.9.0_linux_amd64.zip && \
     unzip tofu_1.9.0_linux_amd64.zip && \
     sudo mv tofu /usr/local/bin/ && \
     rm tofu_1.9.0_linux_amd64.zip" \
    "wget https://github.com/opentofu/opentofu/releases/download/v1.9.0/tofu_1.9.0_linux_amd64.zip && \
     unzip tofu_1.9.0_linux_amd64.zip && \
     sudo mv tofu /usr/local/bin/ && \
     rm tofu_1.9.0_linux_amd64.zip"
echo "OpenTofu installed/updated successfully."

# Install kubectl
install_or_update "kubectl" \
    "sudo apt install -y apt-transport-https ca-certificates curl && \
     sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
     echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
     sudo apt update && \
     sudo apt install -y kubectl" \
    "sudo apt update && sudo apt install --only-upgrade -y kubectl"
echo "kubectl installed/updated successfully."

# Install Helm
install_or_update "helm" \
    "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash" \
    "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
echo "Helm installed/updated successfully."

# Install Trivy
install_or_update "trivy" \
    "sudo apt install -y wget apt-transport-https gnupg lsb-release && \
     wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null && \
     echo 'deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main' | sudo tee -a /etc/apt/sources.list.d/trivy.list && \
     sudo apt update && \
     sudo apt install -y trivy" \
    "sudo apt update && sudo apt install --only-upgrade -y trivy"
echo "Trivy installed/updated successfully."

# Install OPA
install_or_update "opa" \
    "curl -L -o opa https://openpolicyagent.org/downloads/v0.44.0/opa_linux_amd64 && \
     chmod +x opa && \
     sudo mv opa /usr/local/bin/" \
    "curl -L -o opa https://openpolicyagent.org/downloads/v0.44.0/opa_linux_amd64 && \
     chmod +x opa && \
     sudo mv opa /usr/local/bin/"
echo "OPA installed/updated successfully."

# Install Falco
install_or_update "falco" \
    "curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add - && \
     echo 'deb https://download.falco.org/packages/deb stable main' | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list && \
     sudo apt update && \
     sudo apt install -y falco && \
     sudo systemctl start falco && \
     sudo systemctl enable falco" \
    "sudo apt update && sudo apt install --only-upgrade -y falco && \
     sudo systemctl restart falco"
echo "Falco installed/updated successfully."

# Verify installations
echo "Verifying installations..."
docker --version
k3s --version
tofu --version
kubectl version --client
helm version
trivy --version
opa version
falco --version

echo "All tools installed/updated successfully!"