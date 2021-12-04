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

Switches:
    -h, --help     display this help message

Operations:
    help, -h, --help)
        Display this help message.

    build, bd)
        Build a package listed in ~/.local/share/shttr

    install, in)
        Install a package built in ~/.local/share/shttr

    uninstall, un)
        Uninstall a package listed in ~/.local/share/shttr
EOF
}


display_help() {
    cat << eof

shttr - the ass build helper
----------------------------
an aggressively simple software (ass) tool for compiling packages locally.
it fills a similar role as pkgbuilds on arch linux, except that both the
implementation and the packages themselves are much, much simpler as they
only leverage the system package manager for

optional parameters:
    -h      display this help message
    -q      pass quick_deploy flag to hooks.sh scripts to skip redundant work
    -s      skip automated installation of packages.yml dependencies
    -t      run deploy logic only for target directory, specified as argument
    -n      skip all halting messages

eof
}



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

display_help() {
    cat << EOF

Portapotty - deploy script
--------------------------
An aggressively simple software (ASS) suite for keeping my shit together.
By default this script resolves dependencies from packages.yml and runs
hooks from hooks.sh for all subdirectories, but you can tweak this behavior through
the parameters listed below.

Optional parameters:
    -h      display this help message
    -q      pass QUICK_DEPLOY flag to hooks.sh scripts to skip redundant work
    -s      skip automated installation of packages.yml dependencies
    -t      run deploy logic only for target directory, specified as argument
    -n      skip all halting messages

EOF
}
