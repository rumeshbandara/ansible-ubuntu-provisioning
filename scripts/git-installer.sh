#!/usr/bin/env bash

# Define software packages to install
APT_PACKAGES="git"

# Get Git Version
git_version(){
git --version 2>&1 | head -n 1
}

# Configure the PPA and install ansible in master
sudo apt-get update
sudo apt-get install -y $APT_PACKAGES

# Display the installed version
echo -e "\n$(git_version) is installed\n"

exit 0
