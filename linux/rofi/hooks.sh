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
    ensure_dir_exists ~/.config/rofi
    RESOLUTION=$(xrandr | grep '*' | head -n 1 | awk '{ printf $1 }')
    if [[ $RESOLUTION == '3840x2160' ]]; then
        link_config config/simple-light-hidpi.rasi ~/.config/rofi/simple-light.rasi 
    else
        link_config config/simple-light.rasi ~/.config/rofi/simple-light.rasi 
    fi
    link_config config/config.rasi ~/.config/rofi/config.rasi 
fi
