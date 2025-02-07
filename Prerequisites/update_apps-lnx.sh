#!/bin/bash

apps=(
  "docker.io"
  "k3s"
  "terraform"
  "kubectl"
  "helm"
  "git"
  "python3"
)

# Function to update and upgrade the system
update_system() {
  echo "Actualizando el sistema..."
  sudo apt update || { echo "Error al ejecutar apt update. Verifica tu conexión a Internet o los permisos de sudo."; exit 1; }
  sudo apt upgrade -y || { echo "Error al ejecutar apt upgrade. Verifica el sistema."; exit 1; }
  echo "Sistema actualizado."

  # sudo apt update
  # sudo apt upgrade -y
}

check_lock() {
  if sudo fuser /var/lib/dpkg/lock > /dev/null 2>&1; then
    echo "El bloqueo de dpkg está en uso. Esperando..."
    sleep 10
    check_lock
  fi
}

# Function to install or upgrade applications
update_apps() {
  for app in "${apps[@]}"; do
    if dpkg -l | grep -q "^ii  $app "; then
      echo "$app is installed. Upgrading..."
      sudo apt install --only-upgrade -y "$app" || { echo "Error al actualizar $app."; continue; }
      # sudo apt upgrade -y "$app"
    else
      echo "$app is not installed. Installing..."
      sudo apt install -y "$app" || { echo "Error al instalar $app."; continue; }
    fi
  done
}

# Main script execution
check_lock
update_system
update_apps