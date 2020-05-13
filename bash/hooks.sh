#!/bin/bash
source ../pottyfunctions.sh

BASH_CONFIG_DIR="$HOME/.config/bash"
if [[ ! -e "$BASH_CONFIG_DIR" ]]; then
	mkdir -p "$BASH_CONFIG_DIR"
fi

deploy_dotfile "$PWD/dotfiles/bashrc.sh" "$HOME/.bashrc"
deploy_dotfile "$PWD/dotfiles/profile.sh" "$HOME/.profile"
deploy_dotfile "$PWD/dotfiles/defaults.sh" "$BASH_CONFIG_DIR/defaults.sh"
deploy_dotfile "$PWD/dotfiles/aliases.sh" "$BASH_CONFIG_DIR/aliases.sh"
