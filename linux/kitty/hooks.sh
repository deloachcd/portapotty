if [[ $UNAME == linux ]]; then
    ensure_dir_exists ~/.config/kitty
    link_config config/kitty.conf ~/.config/kitty/kitty.conf
fi
