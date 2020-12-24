#!/bin/bash

#########################################
# Check if user is root, else setup vars
#########################################
SUDO=''

if [[ "${EUID}" -ne 0 ]]; then
  SUDO='sudo'
  FOLDER=$HOME/.local/bin
else
  FOLDER=/root/.local/bin
  USER=root
fi

########################################
# Create local/bin folder
########################################
mkdir -p "$FOLDER"

"${SUDO}"  chown -R "$USER:$USER" "$FOLDER"
"${SUDO}"  chmod -R 755 "$FOLDER"

#########################################
# Install Ansible with pip and python3
#########################################
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade setuptools
python3 -m pip install --user -r requirements/requirements_pip.txt
