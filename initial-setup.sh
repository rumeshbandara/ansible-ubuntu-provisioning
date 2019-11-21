#!/usr/bin/env bash

set -e

scriptname=$(basename "$0")

# Run Ansible installer
ansible() {
./scripts/ansible-installer.sh
}

# Run Packer installer
packer() {
./scripts/packer-installer.sh
}

# Run AWS CLI installer
awscli() {
./scripts/awscli-installer.sh
}

# Run Git installer
git() {
./scripts/git-installer.sh
}

# Script help dialog
usage() {
  [[ "$1" ]] && echo -e "Download and install Ansible, Packer, AWS CLI with Git - Latest Versions\n"
  echo -e "usage: ${scriptname} [-a] [-c] [-h]"
  echo -e "     -a\t\t: will install Ansible and Git binaries only"
  echo -e "     -c\t\t: will install the Complete set of packages - Ansible, Packer, AWS CLI and Git binaries"
  echo -e "     -h\t\t: help"
}

# Run without any arguments
if [[ $# -eq 0 ]] ; then
    echo -e "\nThe initial script will install Ansible and Git latest versions\n"
    ansible
    git
    exit 0
fi

# Identify the user parameters and initialize the requested environments
while getopts ":ach" arg; do
  case "${arg}" in
    a)  echo -e "\nThe initial script will install Ansible and Git latest versions\n"; ansible; git; exit;;
    c)  echo -e "\nThe initial script will install the Complete set of packages - Ansible, Packer, AWS CLI and Git latest versions\n"; ansible; packer; awscli; git; exit;;
    h)  usage x; exit;;
    \?) echo -e "Error - Invalid option: $OPTARG"; usage; exit;;
  esac
done
shift $((OPTIND-1))

exit 0
