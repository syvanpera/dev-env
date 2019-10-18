#!/bin/bash
set -e

BRANCH="master"
DISTROS=(fedora ubuntu)

if [ ! "$HOME" == "$PWD" ]; then
  echo "This script is intended to be run from the user's home path: $HOME"
  exit 1
fi

OS=""

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    echo "Distribution identified as $NAME"
fi

if [[ ! " ${DISTROS[@]} " =~ " ${ID} " ]]; then
  echo "Unsupported distribution"
  echo "Currently only following distros are supported: ${DISTROS[@]}"
  exit 1
fi

# BOOTSTRAP

# Upgrade packages
sudo apt-get update
sudo apt-get --assume-yes upgrade

# Install Ansible & Git
sudo apt-get --assume-yes install ansible
sudo apt-get --assume-yes install python3-distutils
sudo apt-get --assume-yes install git

# Clone dev-env repo if not already present
if [ ! -d ".dev-env" ]; then
  git clone --recursive https://github.com/syvanpera/dev-env.git .dev-env
fi

# Checkout specified branch
cd .dev-env
git checkout ${BRANCH}
git fetch
git reset --hard origin/${BRANCH}

# Run Ansible playbook
ansible-playbook ubuntu.yml -i hosts -vv
