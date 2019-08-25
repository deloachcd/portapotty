#!/bin/bash

NEOVIM_CONFIG_DIR=$HOME/.config/nvim
VIM_CONFIG_DIR=$HOME/.vim

# Place neovim binary in user bin
cp ./binaries/nvim* $HOME/.local/bin/nvim

# Place vimrc in home directory
cp ./dotfiles/vimrc $HOME/.vimrc

# Symlink neovim's init.vim to .vimrc
ln -s $HOME/.vimrc $NEOVIM_CONFIG_DIR/init.vim

# Ensure vim autoload plugin dir exists
if [[ ! -d "$VIM_CONFIG_DIR/autoload" ]]; then
	mkdir -p $VIM_CONFIG_DIR/autoload
fi

# Symlink neovim's autoload plugin dir to vim's
ln -s $NEOVIM_CONFIG_DIR/autoload $VIM_CONFIG_DIR/autoload

# Get latest version of vim plug
curl -fLo ./plugins/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Place vim plug in vim's autoload plugin directory
cp ./plugins/plug.vim $HOME/$VIM_CONFIG_DIR/autoload
