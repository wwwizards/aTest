#!/bin/bash
# ABSTRACT: Joey's customizations for Ubuntu 
#  CREATED: 2022-DEC03JN - Initial install usin PNY-8GB thumb drive (BLUE)
#  UPDATED:
# REQUIRES: Ubuntu 20.04-LTS

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

cd $CWD
