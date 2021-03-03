#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
    HOME_VAR='$HOME'
    POTTYNAME="$1"
    mkdir "$POTTYNAME"
    cd "$POTTYNAME"
    touch packages.sh
cat > hooks.sh << EOF
#!/bin/bash
# portapotty deployment: '$POTTYNAME' layer
source ../pottyfunctions.sh
EOF
    cd ..
}

install_packages_from_all_potties() {
    PACKAGES=""
    while read package_list; do
        while read package; do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done < <(cat "$package_list")
    done < <(find . | grep 'packages')
    echo "** INSTALL DEPENDENCIES **"
    sudo zypper in -y $PACKAGES
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
