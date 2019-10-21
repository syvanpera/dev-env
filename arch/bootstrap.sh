#!/bin/bash

# Upgrade packages
sudo pacman -Syu --noconfirm

# Install Ansible
sudo pacman -S ansible --noconfirm --needed

# Install AUR module for Ansible
if [ ! -d "$HOME/.ansible/plugins/modules/aur" ] ; then
  git clone https://github.com/kewlfft/ansible-aur.git $HOME/.ansible/plugins/modules/aur
fi
