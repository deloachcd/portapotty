KONSOLE_DIR="$HOME/.local/share/konsole"

ensure_dir_exists "$KONSOLE_DIR"
link_config "$PWD/share/nord.colorscheme" "$KONSOLE_DIR/nord.colorscheme"
