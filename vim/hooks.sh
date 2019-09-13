#!/bin/bash
source ../pottyfunctions.sh
FLAGS="$@"

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
if [[ ! -d "$NEOVIM_PLUGIN_DIR" ]]; then
	mkdir -p $NEOVIM_PLUGIN_DIR
fi

if [[ "$FLAGS" =~ "compile-latest-vim" ]]; then
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

# Deploy vimrc in home directory
deploy_dotfile "$PWD/dotfiles/vimrc" "$HOME/.vimrc"

# Symlink neovim's init.vim to .vimrc
ln -sf $HOME/.vimrc $NEOVIM_CONFIG_DIR/init.vim

# Symlink vim's plug.vim in neovim's plugin directory
ln -sf "$VIM_PLUGIN_DIR/plug.vim" "$NEOVIM_PLUGIN_DIR/plug.vim"

# Get latest version of vim plug
curl -fLo ./plugins/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Place vim plug in vim's autoload plugin directory
cp ./plugins/plug.vim $VIM_PLUGIN_DIR
