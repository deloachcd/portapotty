#!/bin/bash
source ../pottyfunctions.sh

VIM_CONFIG_DIR=$HOME/.vim
VIM_PLUGIN_DIR=$VIM_CONFIG_DIR/autoload

# Ensure the actual directories we need exist
if [[ ! -d "$VIM_CONFIG_DIR" ]]; then
	mkdir -p $VIM_CONFIG_DIR
fi
if [[ ! -d "$VIM_PLUGIN_DIR" ]]; then
	mkdir -p $VIM_PLUGIN_DIR
fi

# Deploy vimrc in home directory
deploy_dotfile "$PWD/dotfiles/vimrc" "$HOME/.vimrc"

# Get latest version of vim plug
curl -fLo ./plugins/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Place vim plug in vim's autoload plugin directory
cp ./plugins/plug.vim $VIM_PLUGIN_DIR
