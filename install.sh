#!/bin/bash -e

# ########################################################
# Variables
# ########################################################
DIR=tools
GIT_REPO=ansible-ubuntu
GIT_BRANCH=master
GIT_URL=https://github.com/ptavares/"${GIT_REPO}".git

# ########################################################
# Functions
# ########################################################
bold=$(tput bold)
lpurple=$(tput -Txterm setaf 4)
reset=$(tput -Txterm sgr0)


## -------------------------------------------------------
## log function
## -------------------------------------------------------
function log {
    echo "${lpurple}===${reset} ${bold}${1}${reset} ${lpurple}===${reset}"
}

function minimalPackage() {
    log "Install minimum Dependencies Required to run this script"
    sudo apt-get update
    sudo apt install -y git make
}

function checkoutRepo() {
    log " -> Create ${DIR} if not exist"
    cd ~ || exit
    mkdir -p "${DIR}"
    cd "${DIR}" || exit
    if [ ! -d "${GIT_REPO}" ] ; then
        log "Checkout ${GIT_REPO} repository"
        git clone -b "${GIT_BRANCH}" "${GIT_URL}" "${GIT_REPO}"
    else
        log "Update ${GIT_REPO} repository"
        cd "${GIT_REPO}"
        git reset --hard origin/${GIT_BRANCH}
    fi
}

function runBootstrap() {
    cd ~/"${DIR}"/"${GIT_REPO}"
    log "Initial Bootstrap to Setup Machine..."
    make bootstrap

    log "Reload profile to update user path..."
    # shellcheck disable=SC1091
    source /etc/profile

    log "Check BootStrap install..."
    make bootstrap-check
}

function runInstall() {
    cd ~/"${DIR}"/"${GIT_REPO}"
    log "Install all with ansible ..."
    make install-all
}


# ########################################################
# Main
# ########################################################
minimalPackage
checkoutRepo
runBootstrap
runInstall

log "Don't forget to install tmux plugins on first tmux's session with 'prefix + I'"
