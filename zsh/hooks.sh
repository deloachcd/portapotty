link_config home/zshrc ~/.zshrc
link_config config ~/.config/zsh

if [[ $UNAME == linux ]]; then
    # change user's shell to zsh if it's bash
    if cat /etc/passwd | grep $(whoami) | grep bash 2>&1 1>/dev/null; then
        sudo chsh -s /bin/zsh $(whoami)
    fi
fi
