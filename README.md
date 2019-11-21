# Automate the Provisioning of Production Ubuntu Servers using Ansible, Packer & AWS <a href="https://github.com/rumeshbandara/ansible-ubuntu-provisioning"> <img border="0" alt="Ansible" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/ansible.svg" width="32" height="32"> </a><a href="https://github.com/rumeshbandara/ansible-ubuntu-provisioning"> <img border="0" alt="AWS" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/amazonaws.svg" width="32" height="32"> </a>

<a href="https://github.com/rumeshbandara/ansible-ubuntu-provisioning"> <img border="0" alt="Ubuntu Provisioning" src="https://lh3.googleusercontent.com/M4a1fH8F-lVSIEt1QvmtZXFkp0Q9h4xtDNQ-le1PGCuBM9kKgKzaQrFe2-oAqbTlwPDlkP5uL6eb44VQE9a3wNOztdCMl3by7SiHZIWLXvu6tFPAafeWtgRlIljqMe8tDVhN_I2LnDS8dkFfrhbI6f3fl7EoXtDtKqTtzjr9u0tHJfoxaJOs7Ni0YM1d6A1Q4o_ao5cSUgupuxzK0HhUUeKIEQmWnzEbPt-zhyFxUY7NyuWGaMCUYb0Dm_aiyM04vJlpBYo8Yj2D1IoxGyOiU1v6K-FCCZgzyRdVk1VQXg6YZ7l7pevq5_GhUzGyGbMze8oZtd7_3ceFxeZy36UkF2qW4jeASlJGaFGgdsPQPyfqpug0CCyMsyzCtAjsT5AmWTXHa4ijX_Wahm7sEqISMdbaFY5lKKiFMppsw76mscNzODFPyEaDu5zSxkJzyrBNqV64RsZeVAS00EsO_NGO3gCaVxAV9eCNBeijCWKE8Vxx881aji7XZC_JpFrxk-B1DRtwYKPFV1n6ViqRveSpKXLVei0qr_qCn2imh0oTNNs8HnbLaLHsoiu5Bnat2vTZz03xnIOYqn8Oe0BDDZIxYR8ebQ4j9KqBcUUtPrh-X7fqf-jJXfh7Mp9CytroQdDnhFPurv68cOsvNXTxzVOiv2rieOdlz1rr8ClIFHFWeWKbUZonRuWvsQ=w376-h266-no"> </a>

This project define two ways to automate the provisioning of Ubuntu servers (*Refer **Usage** section*):

1) Using Ansible as the only automation tool
2) Using Packer with Ansible to automate the provisioning of an Ubuntu AMI in AWS

>All the automation files and bash scripts were tested in Ubuntu 16.04

The Ansible playbook will automate the provisioning of Ubuntu servers. It will perform following actions out of the box:

* User setup
* SSH hardening
* Firewall setup
* Message of the Day

It will also install the following packages:

* Git
* Vim

Project main directory structure:

```bash
.
├── README.md
├── ansible
├── initial-setup.sh
├── packer
└── scripts
```

## Prerequisites

If you use a Debian based system to provision remote Ubuntu servers, you can run `initial-setup.sh` bash script to install Ansible, Packer, AWS CLI and Git to initialize the environment.
If you already installed the required software, skip to the **Usage** section.

### Initial setup script

Initialization bash scripts will automate the installation of Ansible, Packer, AWS CLI, Git packages and configurations.

Following are the list of initial scripts:

```bash
.
├── initial-setup.sh
└── scripts
    ├── ansible-installer.sh
    ├── awscli-installer.sh
    ├── git-installer.sh
    └── packer-installer.sh
```

Options:

* `-a` Install Ansible and Git binaries only
* `-c` Install Complete set of packages - Ansible, Packer, AWS CLI and Git binaries
* `-h` help

>Running the following script without any parameters will install only the Ansible and Git binaries as the default option.

Run:

```bash
./initial-setup.sh
```

## Usage

### Ansible Only Deployment

Following is the Ansible deployment directory structure:

```bash
.
├── ansible.cfg
├── inventory
│   ├── group_vars
│   │   ├── vars.yml
│   │   └── vault.yml
│   └── hosts
├── provision.yml
└── roles
    ├── common
    │   └── tasks
    │       └── main.yml
    ├── motd
    │   ├── tasks
    │   │   └── main.yml
    │   └── templates
    │       └── motd.j2
    ├── ssh
    │   ├── handlers
    │   │   └── main.yml
    │   └── tasks
    │       └── main.yml
    ├── ufw
    │   └── tasks
    │       └── main.yml
    └── user
        └── tasks
            └── main.yml
```
Go to `ansible` directory.

Configure the `inventory/hosts` file according to your environment.

```yaml
[production]
ubuntu-1 ansible_host=192.168.1.2
```

Edit `inventory/group_vars/vars.yml` file to configure your initial ssh user, new user account, packages to be installed and local SSH public key path.

```yaml
    initial_user: ubuntu
    username: user
    password: "{{ vault_userpasswd }}"
    public_key: ~/.ssh/id_rsa.pub
    sys_packages: [ 'python-apt', 'base-files', 'vim', 'git-core', 'ufw' ]
```

Please note that the new user's password is encrypted using **Ansible Vault**. You can make any changes to the `inventory/group_vars/vault.yml` file to edit the [hashed](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module) sudo password value defined as `vault_userpasswd` variable.

>Current hashed `sudo` password - `devopspass`
>
You can include the vault password in `inventory/group_vars/.vault_pass` as configured in `ansible.cfg` to decrypt the `inventory/group_vars/vault.yml` during an automation pipeline.
>
>Current `vault` password - `devopsvaultpass`

>Assuming that you already copied SSH public key to the remote system using `ssh-copy-id`

Run:

```bash
ansible-playbook provision.yml
```

### Packer with Ansible to provision an Ubuntu AMI in AWS

Following is the Packer with Ansible deployment directory structure:

```bash
.
├── provisioners
│   ├── ansible
│   │   ├── ansible.cfg
│   │   ├── files
│   │   │   └── id_rsa.pub
│   │   ├── inventory
│   │   │   ├── group_vars
│   │   │   │   ├── vars.yml
│   │   │   │   └── vault.yml
│   │   │   └── hosts
│   │   ├── provision.yml
│   │   └── roles
│   │       ├── common
│   │       │   └── tasks
│   │       │       └── main.yml
│   │       ├── motd
│   │       │   ├── tasks
│   │       │   │   └── main.yml
│   │       │   └── templates
│   │       │       └── motd.j2
│   │       ├── ssh
│   │       │   ├── handlers
│   │       │   │   └── main.yml
│   │       │   └── tasks
│   │       │       └── main.yml
│   │       ├── ufw
│   │       │   └── tasks
│   │       │       └── main.yml
│   │       └── user
│   │           └── tasks
│   │               └── main.yml
│   └── scripts
│       └── bootstrap.sh
└── ubuntu-build.json
```

Go to `packer` directory.

Edit `provisioners/ansible/inventory/group_vars/vars.yml` file to configure your initial ssh user, new user account, packages to be installed and local SSH public key path. You can just copy your SSH public key to `provisioners/ansible/files` directory as `id_rsa.pub`.

```yaml
    initial_user: ubuntu
    username: user
    password: "{{ vault_userpasswd }}"
    public_key: ../../files/id_rsa.pub
    sys_packages: [ 'python-apt', 'base-files', 'vim', 'git-core', 'ufw' ]
```
Please note that the new user's password is encrypted using **Ansible Vault**. You can make any changes to the `provisioners/ansible/inventory/group_vars/vault.yml` file to edit the [hashed](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module) sudo password value defined as `vault_userpasswd` variable.

>Current hashed `sudo` password - `devopspass`

You can include the vault password in `provisioners/ansible/inventory/group_vars/.vault_pass` as configured in `provisioners/ansible/ansible.cfg` to decrypt the `provisioners/ansible/inventory/group_vars/vault.yml` file during an automation pipeline.

>Current `vault` password - `devopsvaultpass`

Change `ami_name` and `aws_region` parameters in `ubuntu-build.json` file according to your implementation. The default values set as follows:

```yaml
        "ami_name": "ubuntu-16-ami"
        "aws_region": "ap-southeast-2"
```

>Please make sure to use AWS CLI tool, `aws configure` to set AWS access keys. It's recommended to **avoid** setting up AWS access keys in `ubuntu-build.json` for better security.

Run:

```bash
packer build -machine-readable ubuntu-build.json
```

AMI ID will be printed at the end.

## Contributing

Pull requests are welcome to improve the automation scripts.

## Authors
Rumesh Bandara *<rumeshbandara@gmail.com>*
