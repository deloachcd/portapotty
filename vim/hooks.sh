#!/bin/bash
VIM_CONFIG_DIR=$HOME/.vim
VIM_PLUGIN_DIR=$VIM_CONFIG_DIR/autoload
ensure_dir_exists "$VIM_CONFIG_DIR"
ensure_dir_exists "$VIM_PLUGIN_DIR"

# Deploy vimrc in home directory
deploy_dotfile "$PWD/dotfiles/vimrc" "$HOME/.vimrc"

if [[ "$QUICK_DEPLOY" == false ]]; then
    # Get latest version of vim plug
    curl -fLo ./plugins/plug.vim \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Place vim plug in vim plugin directory if it changed
    if [[ -e $VIM_PLUGIN_DIR/plug.vim ]] && \
            ! diff -q ./plugins/plug.vim $VIM_PLUGIN_DIR/plug.vim; then
        cp ./plugins/plug.vim $VIM_PLUGIN_DIR
    fi
fi

# Place vim plug in vim's autoload plugin directory if it doesn't exist
if [[ ! -e $VIM_PLUGIN_DIR/plug.vim ]]; then
    cp ./plugins/plug.vim $VIM_PLUGIN_DIR
fi

# Symlinks for neovim
if [[ ! -e ~/.config/nvim ]]; then
    ln -s ~/.vim ~/.config/nvim
fi
if [[ ! -e ~/.config/nvim/init.vim ]]; then
    ln -s ~/.vimrc ~/.config/nvim/init.vim
fi

