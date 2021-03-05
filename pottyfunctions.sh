#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
    HOME_VAR='$HOME'
    POTTYNAME="$1"
    mkdir "$POTTYNAME"
    cd "$POTTYNAME"
    touch packages.yml
cat > hooks.sh << EOF
#!/bin/bash
# portapotty deployment: '$POTTYNAME' layer
source ../pottyfunctions.sh
EOF
    cd ..
}

install_packages_from_all_potties() {
    DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | gawk -F '"' '{ print $2 }')"
    if [[ "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
        USER_DISTRO="ubuntu"
        PKG_CMD="apt install"
    elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
        USER_DISTRO="opensuse"
        PKG_CMD="zypper in"
    fi

    PACKAGES=""
    while read packagefile; do
        for package in $(resolve_dependencies "$USER_DISTRO" "$packagefile"); do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done
    done < <(find . | grep 'packages.yml')
    echo "** INSTALL DEPENDENCIES **"
    sudo $PKG_CMD -y $PACKAGES
}

deploy_dotfile() {
    SRC="$1"
    DST="$2"
    cp "$SRC" "$DST"
    cat >> "$HOME/.local/bin/push-up" << EOF
if [[ -e "$DST" ]]; then
    cp "$DST" "$SRC" && echo "$DST -> $SRC"
fi
EOF
}

resolve_dependencies() {
    USER_DISTRO="$1"
    PACKAGE_LISTING_YAML="$2"

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
    done < "$PACKAGE_LISTING_YAML"
    printf "$packages"
}
