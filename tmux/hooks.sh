#!/bin/bash
source ../pottyfunctions.sh

TMUX_CONFIG_DIR="$HOME/.config/tmux"
if [[ ! -e "$TMUX_CONFIG_DIR" ]]; then
    mkdir -p "$TMUX_CONFIG_DIR"
fi

cp ./dotfiles/tmuxline_seoul256 "$TMUX_CONFIG_DIR"
deploy_dotfile ./dotfiles/tmux.conf "$TMUX_CONFIG_DIR"
ln -sf "$TMUX_CONFIG_DIR/tmux.conf" "$HOME/.tmux.conf"
