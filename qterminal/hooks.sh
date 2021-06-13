QTERMINAL_DIR="$HOME/.config/qterminal.org/color-schemes"

ensure_dir_exists $QTERMINAL_DIR
link_config share/nord.colorscheme "$QTERMINAL_DIR/nord.colorscheme"
