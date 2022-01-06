# Ensure user install dir exists and has subdirs we expect
ensure_dir_exists ~/.config
ensure_dir_exists ~/.local/bin
ensure_dir_exists ~/.local/lib
ensure_dir_exists ~/.local/include
ensure_dir_exists ~/.local/share

if [[ $UNAME == linux ]]; then
    ensure_dir_exists ~/.local/share/applications
fi
