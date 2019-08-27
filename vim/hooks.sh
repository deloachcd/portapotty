#!/bin/bash

NEOVIM_CONFIG_DIR=$HOME/.config/nvim
VIM_CONFIG_DIR=$HOME/.vim
NEOVIM_PLUGIN_DIR=$NEOVIM_CONFIG_DIR/autoload
VIM_PLUGIN_DIR=$VIM_CONFIG_DIR/autoload

# Ensure the actual directories we need exist
if [[ ! -d "$VIM_CONFIG_DIR" ]]; then
	mkdir -p $VIM_CONFIG_DIR
fi
if [[ ! -d "$NEOVIM_CONFIG_DIR" ]]; then
	mkdir -p $NEOVIM_CONFIG_DIR
fi
if [[ ! -d "$VIM_PLUGIN_DIR" ]]; then
	mkdir -p $VIM_PLUGIN_DIR
fi

# Place neovim binary in user bin
cp ./binaries/nvim* $HOME/.local/bin/nvim

# Place vimrc in home directory
cp ./dotfiles/vimrc $HOME/.vimrc

# Symlink neovim's init.vim to .vimrc
ln -sf $HOME/.vimrc $NEOVIM_CONFIG_DIR/init.vim

# Symlink neovim's autoload plugin dir to vim's
ln -sf $VIM_PLUGIN_DIR $NEOVIM_PLUGIN_DIR

# Get latest version of vim plug
curl -fLo ./plugins/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Place vim plug in vim's autoload plugin directory
cp ./plugins/plug.vim $VIM_PLUGIN_DIR
