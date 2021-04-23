TMUX_CONFIG_DIR="$HOME/.config/tmux"
ensure_dir_exists "$TMUX_CONFIG_DIR"

# Get tmux plugin manager
if [[ ! -e "$TMUX_CONFIG_DIR/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TMUX_CONFIG_DIR/plugins/tpm"
fi

# Update tpm through git if we're not doing a quick deploy 
if [[ "$QUICK_DEPLOY" == false ]]; then
    WORKING_DIR="$PWD"
    cd "$TMUX_CONFIG_DIR/plugins/tpm"
    git pull
    cd "$WORKING_DIR"
fi

# Deploy tmux config
link_config config/tmux.conf "$TMUX_CONFIG_DIR/tmux.conf"
link_config config/tmux.conf ~/.tmux.conf
