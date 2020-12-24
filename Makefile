# ######################################################################################
# # 						Ansible Ubuntu Makefile
# ######################################################################################

# # Default shell to use
SHELL=/bin/bash
# ========================================
# COLORS SETUP
# ========================================
# to see all colors, run
# bash -c 'for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done'
# the first 15 entries are the 8-bit colors

#  Define standard colors
BLACK        := $(shell tput -Txterm setaf 0)
RED          := $(shell tput -Txterm setaf 1)
GREEN        := $(shell tput -Txterm setaf 2)
YELLOW       := $(shell tput -Txterm setaf 3)
LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
PURPLE       := $(shell tput -Txterm setaf 5)
BLUE         := $(shell tput -Txterm setaf 6)
WHITE        := $(shell tput -Txterm setaf 7)

RESET := $(shell tput -Txterm sgr0)

# set target color
TARGET_COLOR := $(BLUE)

# set message
MESSAGE      = @echo "${LIGHTPURPLE}▶${RESET} $1"
SUCCESS      = @echo "${LIGHTPURPLE}▶${GREEN} $1${RESET}"
# ========================================
# COMMONS VARS
# ========================================
INVENTORY            = inventory
PLAYBOOK_DIR         = playbooks
DEFAULT_REQUIREMENTS = requirements/requirements_ansible.yml

# ========================================
# SETUP VARS
# ========================================
# Add force option to ansible-galaxy command
FORCE ?=
ifeq ($(F), 1)
  force := "--force"
endif
ifneq ("$(limit)", "")
  opts     := $(opts) --limit="$(limit)"
endif
ifneq ("$(tag)", "")
  opts     := $(opts) --tag="$(tag)"
endif
inventory ?= $(INVENTORY)

# === Check if current user is root, ask for password if not provided in command line
ifneq ($(shell id -u), 0)
  ifeq ($(findstring ansible_become_pass, $(args)), ansible_become_pass)
  	opts    := $(opts) $(args)
  else
  	opts     := $(opts) -K
  endif
endif
# ========================================
# COMMANDS
# ========================================
# Main Ansible Playbook Command (prompts for password)
ANSIBLE=ansible-playbook $(playbook) -v -i $(inventory) $(opts) -e 'ansible_user=$(shell whoami)'
# Ansible Galaxy Command
GALAXY=ansible-galaxy install -r $(requirements) $(force)

# ========================================
# TARGETS
# ========================================
.DEFAULT_GOAL := help

# =================================================
## ############## Setup ##############
# =================================================

.PHONY: .bootstrap-before-script
# == Ensure "$$HOME/.local/bin" is part of PATH and source profile
.bootstrap-before-script:
	@$(call MESSAGE, "Ensure "$$HOME/.local/bin" is part of PATH")
	@bash scripts/00-fix-path.sh
	@$(call MESSAGE, "Source folder - ensure initial setup loads this file")
	@. ~/.profile

.PHONY: .bootstrap-before-install
# == Install minimal Apt Dependencies (remove ansible if already)
.bootstrap-before-install:
	$(call MESSAGE, "Minimal Apt Dependencies \(removes apt ansible if exist\)")
	@bash scripts/01-setup.sh

.PHONY: .bootstrap-install
# == Install latest version from pip
.bootstrap-install:
	$(call MESSAGE, "Install last Ansible with pip")
	@bash scripts/02-install-ansible.sh

.PHONY: bootstrap
## Installs dependencies needed to run ansible playbooks
##
bootstrap: .bootstrap-before-script .bootstrap-before-install .bootstrap-install

.PHONY: install-roles
## Install ansible role dependencies
## Usage            : make install-roles [requirements=requirement.yml] [F=1]
## Available args   :
##   - requirements : specify custom requirements file, default set to $(DEFAULT_REQUIREMENTS)
##   - F            : set F=1 to force download if role already exist
install-roles: requirements ?= $(DEFAULT_REQUIREMENTS)
install-roles:
	@$(GALAXY)

# =======================zsh:==========================
## ############## Installation ##############
# =================================================

.PHONY: manage-system
## Call ansible manage-system playbook
##
manage-system: playbook ?= playbooks/manage-system.yml
manage-system: .bootstrap-before-script install-roles
manage-system:
	@$(ANSIBLE)

.PHONY: vscode
## Call ansible vscode playbook
##
vscode: playbook ?= playbooks/vscode.yml
vscode: .bootstrap-before-script install-roles
vscode:
	@$(ANSIBLE)

.PHONY: kubectl
## Call ansible kubectl playbook
##
kubectl: playbook ?= playbooks/kubectl.yml
kubectl: .bootstrap-before-script install-roles
kubectl:
	$(ANSIBLE)

.PHONY: docker
## Call ansible docker playbook
##
docker: playbook ?= playbooks/docker.yml
docker: .bootstrap-before-script install-roles
docker:
	@$(ANSIBLE)

.PHONY: fonts
## Call ansible fonts playbook
##
fonts: playbook ?= playbooks/fonts.yml
fonts: .bootstrap-before-script install-roles
fonts:
	@mkdir -p $${HOME}/tools
	@$(ANSIBLE)
	$(call MESSAGE,  "Install JetBrainsMono font...")
	@source $${HOME}/tools/nerd-fonts/install.sh JetBrainsMono
	$(call MESSAGE,  "Install Mononoki font...")
	@source $${HOME}/tools/nerd-fonts/install.sh Mononoki
	$(call MESSAGE,  "Install DroidSansMono font...")
	@source $${HOME}/tools/nerd-fonts/install.sh DroidSansMono
	$(call MESSAGE,  "Install ProFont font...")
	@source $${HOME}/tools/nerd-fonts/install.sh ProFont
	$(call MESSAGE,  "Install UbuntuMono font...")
	@source $${HOME}/tools/nerd-fonts/install.sh UbuntuMono
	$(call MESSAGE,  "Install SourceCodePro font...")
	@source $${HOME}/tools/nerd-fonts/install.sh SourceCodePro
	$(call MESSAGE,  "Install RobotoMono font...")
	@source $${HOME}/tools/nerd-fonts/install.sh RobotoMono

.PHONY: gnome-shell-extension
## Call ansible gnome-shell-extension playbook
##
gnome-shell-extension: playbook ?= playbooks/gnome-extension.yml
gnome-shell-extension: .bootstrap-before-script install-roles
gnome-shell-extension:
	@$(ANSIBLE)

.PHONY: vim
## Call ansible vim playbook
##
vim: playbook ?= playbooks/vim.yml
vim: .bootstrap-before-script install-roles
vim:
	@$(ANSIBLE)
	$(call MESSAGE,  "Install all vim plugins...")
	yes "" | vim +PlugInstall +qall

.PHONY: tmux
## Call ansible tmux playbook
##
tmux: playbook ?= playbooks/tmux.yml
tmux:.bootstrap-before-script   install-roles
tmux:
	@$(ANSIBLE)

.PHONY: zsh
## Call ansible zsh playbook
zsh: playbook ?= playbooks/zsh.yml
zsh: .bootstrap-before-script install-roles
zsh:
	@$(ANSIBLE)

# =================================================
## ############## Updates ##############
# =================================================
.PHONY: update-zsh-config
## Call ansible zsh playbook with tags="zsh-install-compose"
##
update-zsh-config: playbook ?= playbooks/zsh.yml
update-zsh-config: tags ?= "zsh-install-compose"
update-zsh-config:.bootstrap-before-script install-roles
update-zsh-config:
	@$(ANSIBLE)

.PHONY: update-manage-system
## Call ansible manage-system playbook with tags="manage-system-update, manage-system-clean"
##
update-manage-system: playbook ?= playbooks/manage-system.yml
update-manage-system: tags ?= "manage-system-update, manage-system-clean"
update-manage-system:.bootstrap-before-script install-roles
update-manage-system:
	@$(ANSIBLE)

.PHONY: update-docker-compose
## Call ansible docker playbook with tags="docker-install-compose"
update-docker-compose: playbook ?= playbooks/docker.yml
update-docker-compose: tags ?= "docker-install-compose"
update-docker-compose:.bootstrap-before-script install-roles
update-docker-compose:
	@$(ANSIBLE)

# =================================================
## ############## Test ##############
# =================================================

.PHONY: bootstrap-check
## Check that PATH and requirements are correct
##
bootstrap-check: .bootstrap-before-script
	$(call MESSAGE, "Check that PATH and requirements are correct")
	@ansible --version

.PHONY: build-docker-image
## Build Docker images to test ansible playbooks
build-docker-image: clean
build-docker-image:
	$(call MESSAGE, "Build docker image...")
	docker build -t ansible-ubuntu:test -f docker/Dockerfile .
	@echo
	$(call MESSAGE,  "Start the container with the code inside:")
	$(call SUCCESS,  "docker run --rm -it ansible-ubuntu:test bash")
	$(call MESSAGE,  "Start the container with volume\; so you can change the code directly:")
	$(call SUCCESS,  "docker run --rm -it -v \"\$$PWD\":/home/ubuntu/app/ ansible-ubuntu:test bash")

# =================================================
## ############## Clean ##############
# =================================================
.PHONY: clean
## Clean directory
##
clean:
	$(call MESSAGE, "Remove imported roles...")
	@rm -Rf roles_imported/

# =================================================
## ############## Help ##############
# =================================================
PHONY: precommit
## run precommit on all files
##
precommit:
	pre-commit run --all-files

.PHONY: run-playbook
## Usage                : make run-playbook playbook=<playbook> tags=<tags> limits=<limits> args=<args>
## Required args :
##   - playbook         : playbook to run
## Available args:
##   - tags             : Specify a list of tags for your ansible run
##   - limits           : Limit the command to a subset of hosts with ansible's limit argument
##   - args             : Add ansible understandable arguments
##
run-playbook:
ifndef playbook
	$(error playbook var is required)
endif
	@$(ANSIBLE)

.PHONY: list-playbooks
## List Playbooks
##
list-playbooks: PLAYBOOK_LIST ?= $(wildcard $(PLAYBOOK_DIR)/*.yml)
list-playbooks:
	@for i in $(PLAYBOOK_LIST); do \
		echo $${i}; \
	done

## Show this help
##
.PHONY: help
help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# adds anything that has a double # comment to the phony help list
	@echo "${LIGHTPURPLE}============================================================="
	@echo '               _ _    _              _             _'
	@echo '  __ _ _ _  __(_) |__| |___ ___ _  _| |__ _  _ _ _| |_ _  _'
	@echo " / _\` | ' \(_-< | '_ \ / -_)___| || | '_ \ || | ' \  _| || |"
	@echo ' \__,_|_||_/__/_|_.__/_\___|    \_,_|_.__/\_,_|_||_\__|\_,_|'
	@echo "=============================================================${RESET}"
	@echo "${YELLOW}Usage : ${RESET}"
	@printf "\tmake [target] [arg1=val1] [arg2=val2]...\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "${BLUE}%-20s${RESET}\t %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "${BLUE}%-20s${RESET}\t %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n\t\t\t "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n\t${LIGHTPURPLE}"helpMessage"${RESET}\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)

	@echo ""
	@echo "${YELLOW}With default variables:"
	@echo "-----------------------${RESET}"
	$(call MESSAGE, DEFAULT_REQUIREMENTS = $(DEFAULT_REQUIREMENTS))
	$(call MESSAGE, PLAYBOOK_DIR         = $(PLAYBOOK_DIR))
	@echo ""
