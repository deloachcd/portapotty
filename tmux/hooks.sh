TMUX_CONFIG_DIR="$HOME/.config/tmux"
if [[ ! -e "$TMUX_CONFIG_DIR" ]]; then
    mkdir -p "$TMUX_CONFIG_DIR"
fi

# Get tmux plugin manager
if [[ ! -e "$TMUX_CONFIG_DIR/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TMUX_CONFIG_DIR/plugins/tpm"
fi

# Deploy tmux config
deploy_dotfile "$PWD/dotfiles/tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
if [[ ! -e "$HOME/.tmux.conf" ]]; then
    ln -s "$TMUX_CONFIG_DIR/tmux.conf" "$HOME/.tmux.conf"
fi
