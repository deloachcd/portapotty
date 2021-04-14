# Ensure user install dir exists and has subdirs we expect
ensure_dir_exists "$HOME/.config"
ensure_dir_exists "$HOME/.local/bin"
ensure_dir_exists "$HOME/.local/lib"
ensure_dir_exists "$HOME/.local/include"
ensure_dir_exists "$HOME/.local/share"
