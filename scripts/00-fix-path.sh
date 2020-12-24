#!/bin/bash

#########################################
# Check if user is root, else inject sudo
#########################################
SUDO=''
if [[ "${EUID}" -ne 0 ]]; then
    SUDO='sudo'
fi

########################################################
# Copy script in /etc/profile.d/ to be loaded at launch
########################################################
SCRIPT_LOCAL_BIN_2_PATH=00-add-local-bin-to-path.sh

if test -f "/etc/profile.d/${SCRIPT_LOCAL_BIN_2_PATH}"; then
    echo "${SCRIPT_LOCAL_BIN_2_PATH} already installed."
    exit 0
fi

"${SUDO}" cp scripts/"${SCRIPT_LOCAL_BIN_2_PATH}" /etc/profile.d/"${SCRIPT_LOCAL_BIN_2_PATH}"
"${SUDO}" chmod 0644 /etc/profile.d/"${SCRIPT_LOCAL_BIN_2_PATH}"
