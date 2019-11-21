#!/usr/bin/env bash

# Define software packages to install
APT_PACKAGES="software-properties-common ansible"

# Get Ansible Version
ansible_version(){
ansible --version 2>&1 | head -n 1
}

# Configure the PPA and install ansible in master
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install -y $APT_PACKAGES

# Display the installed version
echo -e "\n$(ansible_version) is installed\n"

# Run an Ad-hoc command to check the availability of each hosts in the inventory. Additionally it will update the ansible master SSH known_hosts file for each host
echo -e "Checking the connectivity of hosts while updating local SSH known_hosts for each defined hosts\n"
cd ansible;ANSIBLE_HOST_KEY_CHECKING=false ansible all -m ping;ANSIBLE_HOST_KEY_CHECKING=true

exit 0
