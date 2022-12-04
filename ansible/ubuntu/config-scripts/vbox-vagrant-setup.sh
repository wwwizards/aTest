#!/bin/bash
# ABSTRACT: quick & dirty script to install IaC Virtualization Layer using VirtualBox-7 hypervisor & vagrant VM manager
#  PROBLEM: virtualbox-7 and vagrant are not included in default apt repos - this is my workaround for installing
#  CREATED: 2022-NOV18JN - Initial install usin PNY-8GB thumb drive (BLUE)
#  UPDATED: 2022-DEC04JN - ADD: Vagrant CLI utilities for managing the VM lifecycles
# REQUIRES: Ubuntu 20.04-LTS
# SEE-ALSO: https://www.virtualbox.org/wiki/Linux_Downloads

# initialize 
CWD=$(pwd)
TMP='tmp'
mkdir $TMP && cd $TMP
# workaround for "E: The repository 'http://download.virtualbox.org/virtualbox/debian jammy InRelease' is not signed."
# VirtualBox - Download GPG keys & install them 
curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg
curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg
# use install to cp & chmod with single command
sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/
sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/
# VirtualBox - Install deb file & update the 'list'
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update && sudo apt install linux-headers-$(uname -r) dkms

# VirtualBox - install latest (or LATEST-STABLE)
#   - ENABLES:  oCloud Integration, USB & Host Webcam Passthrough, vRDP, PXE ROM, Disk Encryption, NVMe.
# fetch LATEST version (VER)
VER=$(wget -qO - https://download.virtualbox.org/virtualbox/LATEST.TXT) && sudo apt install virtualbox-${VER%.*}
# VirtualBox - use vboxmange to install extension pack (optional) 
wget "https://download.virtualbox.org/virtualbox/${VER}/Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack"
vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack

# Vagrant - install vm lifecycle manager (same as above but cleaner)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

#NEXT STEPS: https://developer.hashicorp.com/vagrant/tutorials/getting-started

# housekeeping
cd $CWD
rm -rf $TMP
