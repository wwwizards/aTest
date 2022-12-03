#!/bin/bash
# ABSTRACT: Joey's customizations for Ubuntu 
#  CREATED: 22-NOV18JN - Initial quick & dirty install usin PNY-8GB thumb drive (BLUE)
#  UPDATED: 22-DEC01JN - 
# REQUIRES: Ubuntu 20.04-LTS

# Download and Install Latest Updates
sudo apt-get update && sudo apt-get upgrade
# install PPA helper
sudo apt install software-properties-common

REQUIRED_PKG="ansible"
# update the repo if missing
if ! grep -q "^deb .*$REQUIRED_PKG" /etc/apt/sources.list /etc/apt/sources.list.d/*; then 
    sudo apt-add-repository --yes --update ppa:ansible/ansible
fi
# install latest package if necessary
INSTALLED_PKG=$(dpkg-query -W --showformat='${Package} ${Version} (${Status})\n' $REQUIRED_PKG | grep 'install ok installed')
echo Checking for $REQUIRED_PKG: $INSTALLED_PKG
if [ "" = "$INSTALLED_PKG" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi
# sanity check
dpkg -S $(which $REQUIRED_PKG ) && ansible --version -vvvv || echo " DEPENDENCY ERROR: Uncaught Exception"  
    
# configure ansible apt-module for local execution 
# MORE INFO: $> ansible-doc -t module apt
#  SEE ALSO: https://docs.ansible.com/ansible/latest/dev_guide/developing_locally.html
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
