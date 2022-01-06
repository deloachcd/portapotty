if [[ $UNAME == linux ]]; then
    ensure_dir_exists ~/.fonts
    link_config bundle ~/.fonts/potty
    fc-cache -fv
elif [[ $UNAME == macos ]]; then
    ensure_dir_exists ~/Library/Fonts
    link_config bundle ~/Library/Fonts/potty
fi
