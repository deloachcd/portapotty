# Notify user to import KDE shortcuts (better than messing around with kwriteconfig5)
message_buffer=$(
    cat <<EOF
Now is a good time to import $PWD/config/kwin.kksrc
into KDE for comfier kwin bindings.
EOF
)
halting_message "$message_buffer"
unset $message_buffer

# Deploy xbindkeysrc
link_config config/xbindkeysrc ~/.xbindkeysrc

# Deploy xbindkeys to autostart
link_config config/xbindkeys.desktop ~/.config/autostart/xbindkeys.desktop

# Deploy jumpapp
link_config config/jumpapp ~/.local/bin/jumpapp