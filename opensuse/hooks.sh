DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
if [[ "$DISTRO_LONGNAME" == *"openSUSE"* && $QUICK_DEPLOY == false ]]; then
    # Fix annoying prompt where NetworkManager has to ask for root permission
    # every time you connect to a Wi-Fi network
    if ! sudo cat "/etc/polkit-default-privs.local" | grep NetworkManager 1>/dev/null; then
        sudo su - << EOF
echo "org.freedesktop.NetworkManager.settings.modify.system auth_admin_keep:yes:yes" \
    >> "/etc/polkit-default-privs.local"
/sbin/set_polkit_default_privs
EOF
        echo "NOTE: you will need to log out and log back in for all changes"
        echo "to take effect on openSUSE."
    fi
fi
