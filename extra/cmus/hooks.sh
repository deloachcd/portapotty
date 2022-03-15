ensure_dir_exists ~/.config/cmus
link_config config/rc ~/.config/cmus/rc
link_config config/dpp.theme ~/.config/cmus/dpp.theme

if [[ $UNAME == linux ]]; then
    link_config desktop/cmus.desktop ~/.local/share/applications/cmus.desktop
fi
