#!/bin/bash
# This function should only be sourced, not executed!

install_packages_from_all_potties() {
    local DISTRO="$1"
    if [[ "$DISTRO" == "ubuntu" ]]; then
        local PKG_CMD="apt install"
    elif [[ "$DISTRO" == "opensuse" ]]; then
        local PKG_CMD="zypper in"
    elif [[ "$DISTRO" == "arch" ]]; then
        local PKG_CMD="pacman -S --needed"
    fi

    local PACKAGES=""
    while read packagefile; do
        for package in $(resolve_dependencies "$DISTRO" "$packagefile"); do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done
    done < <(find . | grep 'packages.yml')
    echo "** INSTALL DEPENDENCIES **"
    sudo $PKG_CMD -y $PACKAGES
}

deploy_dotfile() {
    local SRC="$1"
    local DST="$2"
    cp "$SRC" "$DST"
    cat >> "$HOME/.local/bin/push-up" << EOF
if [[ -e "$DST" ]] && ! diff -q "$SRC" "$DST" 1>/dev/null; then
    cp "$DST" "$SRC" && echo "$DST -> $SRC"
fi
EOF
}

resolve_dependencies() {
    local USER_DISTRO="$1"
    local PACKAGE_LISTING_YAML="$2"

    local packages=""
    local distro=NONE
    while read line; do
        if [[ $line =~ ((' '|\t)*\-) && ($distro == all \
                || $distro == $USER_DISTRO) ]]; then
            package=$(echo -n "$line" | awk '{ print $2 }')
            packages+=" $package"
        else
            distro=$(echo -n "$line" | awk '{ print substr($1, 1, length($1)-1) }')
        fi
    done < "$PACKAGE_LISTING_YAML"
    printf "$packages"
}
