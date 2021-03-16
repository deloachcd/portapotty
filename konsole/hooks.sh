LOCAL_INSTALL_DIR=$HOME/.local/share/konsole
if [ ! -d $LOCAL_INSTALL_DIR ]; then
    mkdir -p $LOCAL_INSTALL_DIR
fi
deploy_dotfile "$PWD/dotfiles/nord.colorscheme" "$LOCAL_INSTALL_DIR/nord.colorscheme"
