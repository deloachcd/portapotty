KONSOLE_DIR=$HOME/.local/share/konsole

ensure_dir_exists "$KONSOLE_DIR"
deploy_dotfile "$PWD/dotfiles/nord.colorscheme" "$LOCAL_INSTALL_DIR/nord.colorscheme"
