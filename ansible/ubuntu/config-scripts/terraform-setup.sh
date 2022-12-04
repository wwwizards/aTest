#!/bin/bash
#  PROBLEM: some of my terraform toolkit is version specific - this has been my workaround for several years. great stuff!
# ABSTRACT: quick & dirty script to install tfSwitch 
#  CREATED: 2022-DEC04JN - Initial install usin PNY-8GB thumb drive (BLUE)
#  UPDATED:
# REQUIRES: bash
# SEE-ALSO: https://github.com/warrensbox/terraform-switcher

# initialize
CWD=$(pwd)
TMP='tmp'
mkdir $TMP && cd $TMP
# quick & dirty install terraform using tfswitch
sudo curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash
# TODO: figure out how to use tfswitch w/o sudo -- https://github.com/warrensbox/terraform-switcher/issues/33#issuecomment-498932638
# cleanup
cd $CWD
rm -rf $TMP