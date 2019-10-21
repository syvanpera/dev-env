#!/bin/bash
set -e

# Upgrade packages
sudo apt-get update
sudo apt-get --assume-yes upgrade

# Install Ansible & Git
sudo apt-get --assume-yes install ansible
sudo apt-get --assume-yes install python3-distutils
