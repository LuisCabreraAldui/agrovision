#!/bin/bash

apps=(
  "docker"
  "k3s"
  "terraform"
  "kubectl"
  "helm"
  "opentofu"
  "git"
  "python3"
)

for app in "${apps[@]}"; do
  if brew list "$app" > /dev/null 2>&1; then
    echo "$app is installed. Upgrading..."
    brew upgrade "$app"
  elif brew list --cask "$app" > /dev/null 2>&1; then
    echo "$app is installed as a cask. Upgrading..."
    brew upgrade --cask "$app"
  else
    echo "$app is not installed. Installing..."
    if brew search --cask "$app" > /dev/null 2>&1; then
      brew install --cask "$app"
    else
      brew install "$app"
    fi
  fi
done