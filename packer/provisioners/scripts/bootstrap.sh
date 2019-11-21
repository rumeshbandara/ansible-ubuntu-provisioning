#!/usr/bin/env bash

set -e

# Define software packages to install
APT_PACKAGES="software-properties-common ansible git"

# Configure the PPA and install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install -y $APT_PACKAGES

exit 0
