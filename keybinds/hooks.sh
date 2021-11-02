kwin_write_hotkey() {
    #kquitapp5 kglobalaccel
    #kglobalaccel5
    KEYCHORD="$1"
    NAME="$2"
    kwriteconfig5 --file kglobalshortcutsrc \
        --group kwin \
        --key "$NAME" \
        "$KEYCHORD,none,$NAME"
}

if [[ -e ~/.config/kglobalshortcutsrc ]]; then
    if [[ ! -e ~/.config/kglobalshortcutsrc.original ]]; then
       cp ~/.config/kglobalshortcutsrc ~/.config/kglobalshortcutsrc.original
    fi
    printf "Writing shortcuts to KDE config..."
    ## Keybindings for kwin are set here
    # Windows
    kwin_write_hotkey "Kill Window" "Meta+Q"
    kwin_write_hotkey "Window Close" "Meta+W"
    kwin_write_hotkey "Window Move" "Meta+V"
    kwin_write_hotkey "Window Minimize" "Meta+M"
    kwin_write_hotkey "Window Above Other Windows" "Meta+A"
    kwin_write_hotkey "Window Below Other Windows" "Meta+B"
    # Virtual desktops
    kwin_write_hotkey "Switch One Desktop Down" "Ctrl+Alt+Down"
    kwin_write_hotkey "Switch One Desktop Up" "Ctrl+Alt+Up"
    kwin_write_hotkey "Switch One Desktop to the Left" "Ctrl+Alt+Left"
    kwin_write_hotkey "Switch One Desktop to the Right" "Ctrl+Alt+Right"
    echo "done!"

    printf "Restarting kglobalaccel5..."
    kquitapp5 kglobalaccel
    sleep 2
    kglobalaccel5
    echo "done!"
fi
