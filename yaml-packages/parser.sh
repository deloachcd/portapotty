#!/bin/bash

DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
if [[ "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
    USER_DISTRO="ubuntu"
elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
    USER_DISTRO="opensuse"
fi

packages=
distro=NONE
while read line; do
    if [[ $line == *"all"* ]]; then
        distro=ALL
    elif [[ $line =~ ((' '|\t)*\-) ]]; then
        package="$(echo $line | cut -c 3-)"
        if [[ $distro == ALL || $distro == $USER_DISTRO ]]; then
            packages+=" $package" 
        fi
    else
        distro="$(awk '{ print substr(ENVIRON["line"], 1, length(ENVIRON["line"])-1) }')"
    fi
done < packages.yml
echo $USER_DISTRO
echo $packages
