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
