#!/bin/bash
set -e

BRANCH="master"
DISTROS=(arch fedora ubuntu kubuntu)

DIR=$(dirname $0)

if [ ! "$HOME" == "$PWD" ]; then
  echo "This script is intended to be run from the user's home path: $HOME"
  exit 1
fi

OS=""

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    echo "Distribution identified as $NAME ('$ID' with '$ID_LIKE' base)"
fi

DISTRO=""
if [[ " ${DISTROS[@]} " =~ " ${ID} " ]]; then
  DISTRO=$ID
elif [[ " ${DISTROS[@]} " =~ " ${ID_LIKE} " ]]; then
  DISTRO=$ID_LIKE
else
  echo "Unsupported distribution"
  echo "Currently only following distros are supported: ${DISTROS[@]}"
  exit 1
fi

# BOOTSTRAP

# Clone dev-env repo if not already present
if [ ! -d ".dev-env" ]; then
  git clone --recursive https://github.com/syvanpera/dev-env.git .dev-env
fi

# Checkout specified branch
cd .dev-env
git checkout ${BRANCH}
git fetch
git reset --hard origin/${BRANCH}

source $DISTRO/bootstrap.sh

# Run Ansible playbook
ansible-playbook deploy.yml -i hosts -vv --extra-vars "distro=$DISTRO"
