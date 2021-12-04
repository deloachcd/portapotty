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

get_debfiles() {
    local TARGET="$1"
    apt download "$TARGET"
    dpkg --extract $TARGET*.deb ${TARGET}_debfiles
}

make_package() {
    local SHTTR_PACKAGE_NAME="$1"
    mkdir "$SHTTR_PACKAGE_NAME"
    cp $SHTTR_HOME/templates/recipe.sh "$SHTTR_PACKAGE_NAME/recipe.sh"
    cp $SHTTR_HOME/templates/Makefile "$SHTTR_PACKAGE_NAME/Makefile"
    cp $SHTTR_HOME/templates/shttr.conf "$SHTTR_PACKAGE_NAME/shttr.conf"
}

make_operation() {
    local SHTTR_PACKAGE_NAME="$1"
    local OPERATION="$2"
    if [[ ! -d "$SHTTR_HOME/$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: package '$SHTTR_PACKAGE_NAME' not found!"
    fi
    cd "$SHTTR_HOME/$SHTTR_PACKAGE_NAME"
    env SHTTR_PACKAGE_NAME="$SHTTR_PACKAGE_NAME" make "$OPERATION"
}

build() {
    make_operation "$1" "build"
}

install() {
    make_operation "$1" "install"
}

uninstall() {
    make_operation "$1" "uninstall"
}
