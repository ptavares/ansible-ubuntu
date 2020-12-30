# ansible-ubuntu

![Build](https://github.com/ptavares/ansible-ubuntu/workflows/Build/badge.svg?branch=master)
![GitHub](https://img.shields.io/github/license/ptavares/ansible-ubuntu)

This project contains my personal Ansible playbooks to setup my Ubunty :computer:

## Prerequisite

Ansible must be installed

### Standard installation

#### From apt

```shell script
sudo apt-add-repository -y ppa:ansible/ansible && \
sudo apt-get update && \
sudo apt-get install -y ansible
```

#### From pip

```shell script
sudo apt-get install -y make curl software-properties-common apt-utils python3-setuptools python3-apt python3-pip && \
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py  &&\
    pip install ansible &&\
    rm -rf get-pip.py
```

### Makefile installation

```shell script
git clone https://github.com/ptavares/ansible-ubuntu.git &&\
cd ansible-ubuntu &&\
make bootstrap
```

## Test with Docker

Build the Docker image

```shell script
git clone https://github.com/ptavares/ansible-ubuntu.git &&\
cd ansible-ubuntu &&\
make build-docker-image
```

Start the container with code inside:

```shell script
docker run --rm -it ansible-ubuntu:test bash
```

Start the container with volume, so you can change the code directly:

```shell script
docker run --rm -it -v "$PWD":/home/ubuntu/app/ ansible-ubuntu:test bash
```

## Usage

All ansible playbooks calls are available from a Makefile target :

```shell script
=============================================================
               _ _    _              _             _
  __ _ _ _  __(_) |__| |___ ___ _  _| |__ _  _ _ _| |_ _  _
 / _` | ' \(_-< | '_ \ / -_)___| || | '_ \ || | ' \  _| || |
 \__,_|_||_/__/_|_.__/_\___|    \_,_|_.__/\_,_|_||_\__|\_,_|
=============================================================
Usage : 
        make [target] [arg1=val1] [arg2=val2]...

         ############## Setup ##############

bootstrap:                Installs dependencies needed to run ansible playbooks
                         
install-roles:            Install ansible role dependencies
                          Usage            : make install-roles [requirements=requirement.yml] [F=1]
                          Available args   :
                            - requirements : specify custom requirements file, default set to $(DEFAULT_REQUIREMENTS)
                            - F            : set F=1 to force download if role already exist

         ############## Installation ##############

manage-system:            Call ansible manage-system playbook
                         
vscode:                   Call ansible vscode playbook
                         
kubectl:                  Call ansible kubectl playbook
                         
docker:                   Call ansible docker playbook
                         
fonts:                    Call ansible fonts playbook
                         
gnome-shell-extension:    Call ansible gnome-shell-extension playbook
                         
vim:                      Call ansible vim playbook
                         
tmux:                     Call ansible tmux playbook
                         
zsh:                      Call ansible zsh playbook
                         
appimages:                Call ansible appimages playbook

         ############## Updates ##############

update-zsh-config:        Call ansible zsh playbook with tags="zsh-install-compose"
                         
update-manage-system:     Call ansible manage-system playbook with tags="manage-system-update, manage-system-clean"
                         
update-docker-compose:    Call ansible docker playbook with tags="docker-install-compose"

         ############## Test ##############

bootstrap-check:          Check that PATH and requirements are correct
                         
build-docker-image:       Build Docker images to test ansible playbooks

         ############## Clean ##############

clean:                    Clean directory
                         

         ############## Help ##############

precommit:                run precommit on all files
                         
run-playbook:             Usage                : make run-playbook playbook=<playbook> tags=<tags> limits=<limits> args=<args>
                          Required args :
                            - playbook         : playbook to run
                          Available args:
                            - tags             : Specify a list of tags for your ansible run
                            - limits           : Limit the command to a subset of hosts with ansible's limit argument
                            - args             : Add ansible understandable arguments
                         
list-playbooks:           List Playbooks
                         
help                      Show this help
                         

With default variables:
-----------------------
▶  DEFAULT_REQUIREMENTS = requirements/requirements_ansible.yml
▶  PLAYBOOK_DIR         = playbooks
```

## Detailed Ansible roles

### List playbooks

```shell script
> make list-playbooks

playbooks/vim.yml
playbooks/fonts.yml
playbooks/manage-system.yml
playbooks/docker.yml
playbooks/install-all.yml
playbooks/zsh.yml
playbooks/kubectl.yml
playbooks/vscode.yml
playbooks/appimages.yml
playbooks/gnome-extension.yml
playbooks/tmux.yml
```

#### docker playbook

Will install  `docker` and `docker-compose`.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)
  * [ansible-role-docker](https://github.com/ptavares/ansible-role-docker)

* Local configuration file
  * [docker.yml](./group_vars/computer/tools/docker.yml)

* Makefile targets

    ```shell script
    make docker
    make update-docker-compose
    ```

#### fonts playbook

Will clone [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) into your `${HOME}/tools` directory.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * none

* Makefile target
  * After cloning [nerd-fonts](https://github.com/ryanoasis/nerd-fonts), run installation of this fonts :
    * JetBrainsMono
    * Mononoki
    * DroidSansMono
    * ProFont
    * UbuntuMono
    * SourceCodePro
    * RobotoMono

    ```shell script
    make fonts
    ```

#### kubectl playbook

Will install `kubectl` CLI

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)
  * [ansible-role-kubectl](https://github.com/ptavares/ansible-role-kubectl)

* Local configuration file
  * none (but you can specify one)

* Makefile targets (can be called for updates too)

    ```shell script
    make kubectl
   ```

#### tmux playbook

Will install `tmux` and `tmuxinator` with my custom tmux configuration files if wanted.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [tmux.yml](./group_vars/computer/tools/tmux.yml)

* Makefile targets

    ```shell script
    make tmux
    ```

`tmux` configuration file is based on this [one](https://github.com/gpakosz/.tmux) and needs extra plugins :

* [tpm](https://github.com/tmux-plugins/tpm)
* [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
* [tmux-cpu](https://github.com/tmux-plugins/tmux-sensible)
* [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
* [tmux-net-speed](https://github.com/tmux-plugins/tmux-net-speed)
* [tmux-plugin-mem](https://github.com/GROG/tmux-plugin-mem)
* [tmux-better-mouse-mode](https://github.com/NHDaly/tmux-better-mouse-mode)

#### vim playbook

Will install `vim` with my custom vim configuration file if wanted.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [vim.yml](./group_vars/computer/tools/vim.yml)

* Makefile targets

    ```shell script
    make vim
    # Makefle target will call this command line :
    # > vim +PlugInstall +qall
    ```

`vim` configuration will install [molokai](https://github.com/tomasr/molokai.git) color theme and my custom plugins from [vim bootstrap](https://vim-bootstrap.com/)

#### vscode playbook

Will install `vscode` and some plugins (see configuration file for details)

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [vscode.yml](./group_vars/computer/tools/vscode.yml)

* Makefile targets

    ```shell script
    make vscode
    ```

#### zsh playbook

Will install `zsh` with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and some useful plugins (see configuration file for details)

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)
  * [ansible-role-oh-my-zsh](https://github.com/ptavares/ansible-role-oh-my-zsh)

* Local configuration file
  * [zsh.yml](./group_vars/computer/system/zsh.yml)

* Makefile targets

    ```shell script
    make zsh
    make update-zsh-config
    ```

#### manage-system playbook

Will manage system updates and package/deb install/remove.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [system.yml](./group_vars/computer/system/system.yml)

* Makefile targets

    ```shell script
    make manage-system
    make update-manage-system
    ```

#### gnome-extension playbook

Will download and install some usefull gnome-shell-extension using [gnome-shell-extension-installer](https://github.com/brunelli/gnome-shell-extension-installer).

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [gnome-extensions.yml](./group_vars/computer/tools/gnome-extensions.yml)

* Makefile targets

    ```shell script
    make gnome-shell-extension
    ```

#### AppImages playbook

Will download and install AppImages.

* Dependencies
  * [ansible-role-manage-system](https://github.com/ptavares/ansible-role-manage-system)

* Local configuration file
  * [appimages.yml](./group_vars/computer/tools/appimages.yml)

* Makefile targets

    ```shell script
    make appimages
    ```
