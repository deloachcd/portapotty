#!/bin/bash
# portapotty deployment: 'zsh' layer
source ../pottyfunctions.sh

deploy_dotfile ./dotfiles/zshrc $HOME/.zshrc
