#!/bin/bash
set -e

# Upgrade packages
sudo dnf update -y

# Install Ansible
sudo dnf install ansible -y
