#!/bin/bash
# ABSTRACT: Joey's customizations for Ubuntu 
#  CREATED: 2022-NOV18JN - Initial install usin PNY-8GB thumb drive (BLUE)
#  UPDATED:
# REQUIRES: Ubuntu 20.04-LTS

# POST-PROVISION HARDENING 
## STEP-1. Download and Install Latest Updates
sudo apt-get update && sudo apt-get upgrade
# install tools for tweaking GUI
sudo add-apt-repository universe
sudo apt install gnome-tweaks #Previously known as Tweak Tool.
# quick & dirty enable personal firewall & install gui tools for it
# SEE ALSO: https://github.com/Oefenweb/ansible-ufw 
sudo ufw enable
sudo apt-get install gufw

# install ansible
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible && sudo apt install ansible
# install ansible apt-module
sudo ansible localhost -m apt -a "name=elinks state=present" --become --connection local

# create ansible directory skeletons
CWD=$(pwd)
ANSIBLE_HOME='~/data/projects/tools/ansible/ubuntu'
PLAYBOOKS_HOME="$ANSIBLE_HOME/playbooks"
ENV_LIST='UNKNOWN DEV STAGE PROD'
mkdir -pv $PLAYBOOKS_HOME && cd $PLAYBOOKS_HOME

# create basic-multi-env structure
mkdir -pv group_vars host_vars library filter_plugins
cd group_vars
for ENVIRONMENT in $ENV_LIST ; do echo -e "---\nserverMode: $ENVIRONMENT" > $ENVIRONMENT; done
mv -v UNKNOWN ALL
touch dev stage prod site.yml 
cd -
# create basic-roles skeleton
mkdir -pv roles/template/{tasks,handlers,templates,files,vars,defaults,meta}
# set defaults
echo "[defaults]

host_key_checking = False" >> roles/ansible.cfg
#create yml files
touch roles/template/{tasks,handlers,templates,files,vars,defaults,meta}/main.yml


###################################################################################################

#create playbook for base packages
#cat << EOF > /tmp/yourfilehere


#EOF

cd $CWD

# Install Vagrant-7 Hypervisor

# Vagrant - Download GPG keys & install them 
curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg
curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg

sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/
sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/
# Vagrant - Install deb file
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.0
# Vagrant - install extension pack
cd ~/
wget https://download.virtualbox.org/virtualbox/7.0.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack

# Other Tools

# install terraform & tfswitch
sudo curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash
# TODO: figure out how to use tfswitch w/o sudo 
