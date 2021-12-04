#!/bin/bash

#             mm
#             ##          ##        ##
#   mm#####m  ##m####m  #######   #######    ##m####
#   ##mmmm "  ##"   ##    ##        ##       ##"
#    """"##m  ##    ##    ##        ##       ##
#   #mmmmm##  ##    ##    ##mmm     ##mmm    ##
#    """"""   ""    ""     """"      """"    ""
#
#  "...because the AUR is overcomplicated S-H-I-T!"

# run in bash 'strict mode'
set -euo pipefail

SHTTR_HOME=$HOME/.local/share/shttr

display_help() {
    cat << EOF

shttr - the ASS build helper
----------------------------
An aggressively simple software (ASS) tool for managing build automation.
It allows an extremely easy to understand framework (provided you know bash)
for scripting out build instructions for projects on github/gitlab/etc,
and installing them where they can be executed in the user's home directory.

Operations:
    help, -h, --help)
        Display this help message.

    build, bd)
        Build a package listed in ~/.local/share/shttr

    install, in)
        Install a package built in ~/.local/share/shttr

    uninstall, un)
        Uninstall a package listed in ~/.local/share/shttr

    make-package, mp)
        Create a new package listing in ~/.local/share/shttr

    get-debfiles, gd)
        Download and unpack APT's file listing to get .desktop files
        and icons which can aid in quicker package creation.

EOF
}

_get_debfiles() {
    local TARGET="$1"
    apt download "$TARGET"
    dpkg --extract $TARGET*.deb ${TARGET}_debfiles
}

_make_package() {
    local SHTTR_PACKAGE_NAME="$1"
    mkdir "$SHTTR_PACKAGE_NAME"
    cp $SHTTR_HOME/templates/recipe.sh "$SHTTR_PACKAGE_NAME/recipe.sh"
    cp $SHTTR_HOME/templates/Makefile "$SHTTR_PACKAGE_NAME/Makefile"
    cp $SHTTR_HOME/templates/shttr.conf "$SHTTR_PACKAGE_NAME/shttr.conf"
}

__make_operation() {
    local SHTTR_PACKAGE_NAME="$1"
    local OPERATION="$2"
    if [[ -z "$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: nothing to $OPERATION!"
        exit -2
    elif [[ ! -d "$SHTTR_HOME/$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: package '$SHTTR_PACKAGE_NAME' not found!"
        exit -2
    fi
    cd "$SHTTR_HOME/$SHTTR_PACKAGE_NAME"
    env SHTTR_PACKAGE_NAME="$SHTTR_PACKAGE_NAME" make "$OPERATION"
}

# Argument parsing
if [[ -z "$1" ]]; then
    display_help
    exit -1
elif [[ "help" =~ "$1" || "-h" == "$1" ]]; then
    display_help
fi

OPERATION="$1"
TARGET="$2"

case "$OPERATION" in
    build | bd)
        __make_operation "$TARGET" "build"
        ;;

    install | in)
        __make_operation "$TARGET" "install"
        ;;

    uninstall | un)
        __make_operation "$TARGET" "uninstall"
        ;;

    make-package | mp)
        _make_package "$TARGET"
        ;;

    get-debfiles | gd)
        _get_debfiles  "$TARGET"
        ;;
esac
