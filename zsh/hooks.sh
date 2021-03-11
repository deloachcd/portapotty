ZSH_CONFIG_DIR="$HOME/.config/zsh"
if [[ ! -e "$ZSH_CONFIG_DIR" ]]; then
    mkdir -p "$ZSH_CONFIG_DIR"
fi

deploy_dotfile "$PWD/dotfiles/zshrc" "$HOME/.zshrc"
deploy_dotfile "$PWD/dotfiles/profile.sh" "$HOME/.profile"
deploy_dotfile "$PWD/dotfiles/constants.sh" "$ZSH_CONFIG_DIR/constants.sh"
deploy_dotfile "$PWD/dotfiles/prompt.sh" "$ZSH_CONFIG_DIR/prompt.sh"
deploy_dotfile "$PWD/dotfiles/path.sh" "$ZSH_CONFIG_DIR/path.sh"
deploy_dotfile "$PWD/dotfiles/aliases.sh" "$ZSH_CONFIG_DIR/aliases.sh"

# change user's shell to zsh if it's bash
if cat /etc/passwd | grep $(whoami) | grep bash 2>&1 1>/dev/null; then
    chsh -s /bin/zsh
fi
