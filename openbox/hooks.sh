# ensure we have an entry in SDDM for launching an Openbox/KDE session
if [[ ! -e /usr/share/xsessions/openbox-kde.desktop ]]; then
    sudo cp config/openbox-kde.desktop /usr/share/xsessions/openbox-kde.desktop
fi

# ensure we have the script for launching our Openbox/KDE session
if [[ ! -e /usr/bin/openbox-kde-session ]]; then
    sudo cp script/openbox-kde-session  /usr/bin/openbox-kde-session 
fi

ensure_dir_exists ~/.config/openbox
link_config config/rc.xml ~/.config/openbox/rc.xml
