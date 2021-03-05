#!/bin/bash

DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | gawk -F '"' '{ print $2 }')"
if [[ "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
    USER_DISTRO="ubuntu"
    PKG_CMD="apt install"
elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
    USER_DISTRO="opensuse"
    PKG_CMD="zypper in"
fi

packages=""
distro=NONE
while read line; do
    if [[ $line =~ ((' '|\t)*\-) && ($distro == all \
            || $distro == $USER_DISTRO) ]]; then
        package=$(echo -n "$line" | gawk '{ print $2 }')
        packages+=" $package"
    else
        distro=$(echo -n "$line" | gawk '{ print substr($1, 1, length($1)-1) }')
    fi
done < packages.yml
RESOLVE_DEPENDENCIES="sudo $PKG_CMD $packages"
echo $RESOLVE_DEPENDENCIES
