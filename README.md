Development Environment Configuration with Ansible
==================================================

[![License: MIT](https://img.shields.io/badge/license-MIT%20License-blue.svg)](https://raw.githubusercontent.com/syvanpera/dev-env/master/LICENSE)

## Install Ansible
```shell
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible
```

## Run it
```shell
wget -qO- https://raw.github.com/syvanpera/dev-env/master/bootstrap.sh | bash
```
or
```shell
ansible-playbook -K bootstrap.yml --extra-vars "project=xxxx"

```
## Disclaimer
This is just for personal convenience. It's not intended to be highly configurable and I'm most likely not following Ansible's conventions and best practices.

## TODO
Node is not installed with apt right now as the version available in the default repository is old. To install at least v20,
use [nodesource](https://github.com/nodesource/distributions/blob/master/README.md)

## License
[MIT License](LICENSE)
