#!/bin/bash

#########################################
# Check if user is root, else inject sudo
#########################################
SUDO=''
if [[ "${EUID}" -ne 0 ]]; then
    SUDO='sudo'
fi

###########################################
# First remove ansible if already installed
# #########################################
"${SUDO}" apt remove -y ansible
"${SUDO}" apt -y autoremove

################
# update system
################
"${SUDO}" apt update

########################
# Install Python3 & Pip3
########################
"${SUDO}" apt install -y software-properties-common apt-utils
"${SUDO}" apt install -y python3-setuptools python3-apt python3-pip
