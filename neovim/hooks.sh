#!/bin/bash
VIM_AUTOLOAD_DIR="$HOME/.vim/autoload"
NEOVIM_AUTOLOAD_DIR="$HOME/.local/share/nvim/site/autoload"
ensure_dir_exists "$VIM_AUTOLOAD_DIR"
ensure_dir_exists "$NEOVIM_AUTOLOAD_DIR"

# Deploy vimrc in home directory
link_config "$PWD/config" "$HOME/.config/nvim"
link_config "$PWD/config/init.vim" "$HOME/.vimrc"
link_config "$NEOVIM_AUTOLOAD_DIR" "$VIM_AUTOLOAD_DIR"

if [[ "$QUICK_DEPLOY" == false ]]; then
    # Get latest version of vim plug
    curl -fLo plug.vim \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Place vim plug in autoload directory if it has been updated
    if [[ -e $NEOVIM_AUTOLOAD_DIR/plug.vim ]] && \
            ! diff -q plug.vim $VIM_AUTOLOAD_DIR/plug.vim; then
        mv plug.vim $NEOVIM_AUTOLOAD_DIR/plug.vim
    elif [[ -e $NEOVIM_AUTOLOAD_DIR/plug.vim ]]; then
        rm plug.vim
    fi
fi

# Place vim plug in vim's autoload plugin directory if it doesn't exist
if [[ ! -e $NEOVIM_AUTOLOAD_DIR/plug.vim ]]; then
    if [[ ! -e plug.vim ]]; then
        curl -fLo $NEOVIM_AUTOLOAD_DIR/plug.vim \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        mv plug.vim $NEOVIM_AUTOLOAD_DIR/plug.vim
    fi
fi
