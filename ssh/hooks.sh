#!/bin/bash
# portapotty deployment: 'ssh' layer
source ../pottyfunctions.sh

mkdir -p $HOME/.config/ssh
deploy_dotfile ./dotfiles/sshrc $HOME/.sshrc
cp ./script/sshrc_everywhere.sh $HOME/.config/ssh
