#!/bin/bash

# Upgrade packages
sudo pacman -Syu --noconfirm

# Install Ansible & needed packages
sudo pacman -S ansible python-psutil --noconfirm --needed

# Install the aur module into the user custom module directory
mkdir ~/.ansible/plugins/modules
curl -o ~/.ansible/plugins/modules/aur.py https://raw.githubusercontent.com/kewlfft/ansible-aur/master/plugins/modules/aur.py

# Install AUR module for Ansible
#if [ ! -d "$HOME/.ansible/plugins/modules/aur" ] ; then
#  git clone https://github.com/kewlfft/ansible-aur.git $HOME/.ansible/plugins/modules/aur
#fi
