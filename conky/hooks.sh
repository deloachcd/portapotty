CONKY_CONFIG_DIR="$HOME/.config/conky"

ensure_dir_exists "$CONKY_CONFIG_DIR"
deploy_dotfile "$PWD/dotfiles/conky.conf" "$CONKY_CONFIG_DIR/conky.conf"
