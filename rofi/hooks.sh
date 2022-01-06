message_buffer=$(
    cat <<EOF
If you're deploying on a fresh KDE install, bind this command for rofi:
rofi -modi combi -show combi -combi-modi window,drun,run
EOF
)

if [[ $UNAME == linux ]]; then
    if [[ ! -e ~/.config/rofi ]]; then
        halting_message "$message_buffer"
        unset message_buffer
    fi
    link_config config ~/.config/rofi
fi
