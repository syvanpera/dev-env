#!/bin/bash

# Upgrade packages
sudo pacman -Syu --noconfirm

# Install Ansible
sudo pacman -S ansible --noconfirm --needed

# Install AUR module for Ansible
git clone https://github.com/kewlfft/ansible-aur.git ~/.ansible/plugins/modules/aur
