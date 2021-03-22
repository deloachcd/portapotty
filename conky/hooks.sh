CONKY_CONFIG_DIR="$HOME/.config/conky"
if [[ ! -e "$CONKY_CONFIG_DIR" ]]; then
    mkdir -p "$CONKY_CONFIG_DIR"
fi

deploy_dotfile "$PWD/dotfiles/conky.conf" "$CONKY_CONFIG_DIR/conky.conf"
