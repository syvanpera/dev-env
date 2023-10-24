#!/bin/bash

# Upgrade packages
sudo apt update
sudo apt upgrade -y

# Install Ansible & needed packages
sudo apt install ansible -y
