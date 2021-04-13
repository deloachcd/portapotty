link_config "$PWD/home/zshrc" "$HOME/.zshrc"
link_config "$PWD/config" "$HOME/.config/zsh"

# change user's shell to zsh if it's bash
if cat /etc/passwd | grep $(whoami) | grep bash 2>&1 1>/dev/null; then
    sudo chsh -s /bin/zsh $(whoami)
fi
