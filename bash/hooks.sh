#!/bin/bash
source ../pottyfunctions.sh

BASH_CONFIG_DIR="$HOME/.config/bash"
if [[ ! -e "$BASH_CONFIG_DIR" ]]; then
	mkdir -p "$BASH_CONFIG_DIR"
fi

deploy_dotfile "$PWD/dotfiles/bashrc" "$HOME/.bashrc"
deploy_dotfile "$PWD/dotfiles/profile.sh" "$HOME/.profile"
deploy_dotfile "$PWD/dotfiles/constants.sh" "$BASH_CONFIG_DIR/constants.sh"
deploy_dotfile "$PWD/dotfiles/prompt.sh" "$BASH_CONFIG_DIR/prompt.sh"
deploy_dotfile "$PWD/dotfiles/path.sh" "$BASH_CONFIG_DIR/path.sh"
deploy_dotfile "$PWD/dotfiles/aliases.sh" "$BASH_CONFIG_DIR/aliases.sh"
