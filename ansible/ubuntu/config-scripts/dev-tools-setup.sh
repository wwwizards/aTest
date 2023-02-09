#!/bin/bash
# ABSTRACT: Joey's Custom Tweaks for Ubuntu IaC Development  Environment
#  CREATED: 2022-NOV18JN - Initial install usin PNY-8GB thumb drive (BLUE)
#  UPDATED: 2022-DEC04JN - 
# REQUIRES: Apt Package Manager - tested w/Ubuntu-20.04-LTS

export SCRIPTPATH="$( cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 ; pwd -P )"
echo $SCRIPTPATH # Sanity Check

# POST-PROVISION UPDATES 
sudo apt-get update && sudo apt-get upgrade

# PKG-DEPENDENCIES - uses cache & hard-coded strings to aviod issues with broken packages or using a brute force loop 
sudo apt-cache --generate pkgnames \
| grep --line-regexp --fixed-strings \
  -e curl \
  -e zip \
  -e unzip \
  -e vim \
| xargs sudo apt install -y

# install tools for tweaking GUI
sudo add-apt-repository universe
sudo apt install gnome-tweaks #Previously known as Tweak Tool.

# BEFORE ANYTHING ELSE: Enable ufw - an ubuntu enhancement for managing iptables
# quick & dirty script to enable personal firewall & optionally install gui tools for it
# SEE: https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-20-04/
sudo ufw allow ssh #! IMPORTANT: especially if you are using ansible and/or working remotely...
sudo ufw enable
sudo apt-get install gufw # optional

# MORE ADVANCED: these configs can be managed via ansible playbooks
# SEE: https://github.com/Oefenweb/ansible-ufw
# SEE ALSO: https://docs.ansible.com/ansible/latest/collections/community/general/ufw_module.html 


# install & configure terraform using tfswitch
sudo bash $SCRIPTPATH/terraform-setup.sh

# install virtualbox
sudo bash $SCRIPTPATH/virtualbox-setup.sh

# install ansible
sudo bash $SCRIPTPATH/ansible-setup.sh
