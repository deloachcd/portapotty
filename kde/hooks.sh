# Ensure we're using sudo instead of the root password for kdesu if we're running openSUSE
if cat /etc/os-release | grep "openSUSE" 2>&1 1>/dev/null && [ ! -e $HOME/.config/kdesurc ]; then
    kwriteconfig5 --file kdesurc --group super-user-command --key super-user-command sudo
fi
