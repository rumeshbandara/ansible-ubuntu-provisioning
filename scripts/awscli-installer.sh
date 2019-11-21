#!/usr/bin/env bash

# Define software packages to install
APT_PACKAGES="python-pip"

# Install required packages
sudo apt-get update
sudo apt-get install -y $APT_PACKAGES

# Install AWS cli
sudo pip install awscli

# Display the message
echo -e "\nAWS CLI is installed\n"

exit 0
