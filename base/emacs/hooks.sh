if [[ ! -d ~/.emacs.d ]]; then
   git clone git@github.com:deloachcd/emacs.git ~/.emacs.d
fi

if [[ $UNAME == darwin && $INSTALL_PACKAGES == true ]]; then
    EMACS_FORMULA="emacs-plus@28"
    EMACS_OPTIONS="--with-native-comp"
    echo
    uline_echo "The following formula will be installed:"
    echo "$EMACS_FORMULA"
    echo
    brew tap d12frosted/emacs-plus
    brew install $EMACS_FORMULA $EMACS_OPTIONS
    if [[ ! -e /Applications/Emacs.app ]]; then
        ln -s /usr/local/opt/$EMACS_FORMULA/Emacs.app /Applications
    fi
fi
