#!/bin/bash
# portapotty deployment: 'zsh' layer
source ../pottyfunctions.sh

deploy_dotfile ./dotfiles/zshrc $HOME/.zshrc
deploy_dotfile ./dotfiles/zprofile $HOME/.zprofile
