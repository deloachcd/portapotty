OPENBOX_CONFIG_DIR="$HOME/.config/openbox"

ensure_dir_exists "$OPENBOX_CONFIG_DIR"
if [[ ! -e "$OPENBOX_CONFIG_DIR/lxqt-rc.xml" ]] || cat "$OPENBOX_CONFIG_DIR/lxqt-rc.xml" | grep "DLIMC" 1>/dev/null; then
    cp config/rc.xml "$OPENBOX_CONFIG_DIR/lxqt-rc.xml"
fi
if [[ ! -e "$OPENBOX_CONFIG_DIR/rc.xml" ]]; then
    ln -s "$OPENBOX_CONFIG_DIR/lxqt-rc.xml" "$OPENBOX_CONFIG_DIR/rc.xml"
fi
