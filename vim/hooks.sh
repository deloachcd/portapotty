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

FLAGS="$@"
if [[ ! "$FLAGS" =~ "no-compile" ]]; then
	# Clone official vim repo
	git clone https://github.com/vim/vim

	# Enter latest vim's source dir
	cd ./vim/src

	# Ensure we have all of vim's build dependencies installed
	sudo apt build-dep -y vim

	# Configure for user installation
	./configure --prefix=$HOME/.local && make && make install

	# Leave latest vim's source dir
	cd ../..

	# Clean up
	rm -rf ./vim
fi

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
