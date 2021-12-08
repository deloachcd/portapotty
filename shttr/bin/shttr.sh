#!/bin/bash -e

#             mm
#             ##          ##        ##
#   mm#####m  ##m####m  #######   #######    ##m####
#   ##mmmm "  ##"   ##    ##        ##       ##"
#    """"##m  ##    ##    ##        ##       ##
#   #mmmmm##  ##    ##    ##mmm     ##mmm    ##
#    """"""   ""    ""     """"      """"    ""
#
#  "...because the AUR is overcomplicated S-H-I-T!"

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

    list, lt)
        List packages in ~/.local/share/shttr, and if they're installed

    make-package, mp)
        Create a new package listing in ~/.local/share/shttr

    get-debfiles, gd)
        Download and unpack APT's file listing to get .desktop files
        and icons which can aid in quicker package creation.

EOF
}

_get_debfiles() {
    # NOTE: wildcard $TARGET*.deb extraction/deletion isn't very clean, but
    # I don't know if 'apt download' has an output flag that makes using it
    # unnecessary
    local TARGET="$1"
    apt download "$TARGET"
    dpkg --extract $TARGET*.deb ${TARGET}_debfiles
    rm $TARGET*.deb
}

_make_package() {
    local SHTTR_PACKAGE_NAME="$1"
    # Create directory for package listing
    echo "Creating package listing for '$SHTTR_PACKAGE_NAME' in '$SHTTR_HOME/pkgs'"
    mkdir "$SHTTR_HOME/pkgs/$SHTTR_PACKAGE_NAME"
    cd "$SHTTR_HOME/pkgs/$SHTTR_PACKAGE_NAME"

    # Copy over initial templates
    cp $SHTTR_HOME/templates/recipe.sh .
    cp $SHTTR_HOME/templates/Makefile .
    cp $SHTTR_HOME/templates/shttr.conf .

    # Check if package exists in APT, and we can look for desktop files/icons there
    if apt-cache show "$SHTTR_PACKAGE_NAME" 1>/dev/null 2>&1; then
        # Package exists in APT, pull archive and look for anything useful
        echo "Package exists in apt, pulling .deb archive to look for desktop files and icons"
        _get_debfiles "${SHTTR_PACKAGE_NAME}"
        cd ${SHTTR_PACKAGE_NAME}_debfiles

        # Pull desktop files (or write generic template)
        if [[ -e usr/share/applications/${SHTTR_PACKAGE_NAME}.desktop ]]; then
            echo "Hit ${SHTTR_PACKAGE_NAME}.desktop, copying it"
            mv usr/share/applications/${SHTTR_PACKAGE_NAME}.desktop \
                ../${SHTTR_PACKAGE_NAME}.desktop
        elif [[ -d usr/share/applications/ ]]; then
            echo "Hit /usr/share/applications directory, copying as applications/"
            mv usr/share/applications ..
        else
            echo "Couldn't find any desktop files, copying generic template as default.desktop"
            cp ../../../templates/default.desktop ..
        fi

        # Pull icons (or write generic one)
        if [[ -d usr/share/pixmaps/ ]]; then
            echo "Found /usr/share/pixmaps directory, copying it"
            mv usr/share/pixmaps ..
        else
            echo "Couldn't find any pixmaps, copying generic 256x256 icon into pixmaps/"
            mkdir ../pixmaps
            cp ../../../templates/shttr.png ../pixmaps/shttr.png
        fi

        cd ..
        rm -r ${SHTTR_PACKAGE_NAME}_debfiles
    else
        echo "Couldn't find any desktop files, copying generic template as default.desktop"
        cp ../../templates/default.desktop .
        echo "Couldn't find any pixmaps, copying generic 256x256 icon into pixmaps/"
        mkdir pixmaps
        cp ../../templates/shttr.png pixmaps/shttr.png
    fi
}

_list() {
    for entry in $(ls $SHTTR_HOME/pkgs | grep -vi templates); do
        printf "$entry"
        if [[ -e ~/.local/bin/$entry ]]; then
            printf " [installed]"
        fi
        echo
    done
}

__make_operation() {
    local SHTTR_PACKAGE_NAME="$1"
    local OPERATION="$2"
    if [[ -z "$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: nothing to $OPERATION!"
        exit -2  # TODO figure out if this is the correct error code
    elif [[ ! -d "$SHTTR_HOME/pkgs/$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: package '$SHTTR_PACKAGE_NAME' not found!"
        exit -2
    fi
    cd "$SHTTR_HOME/pkgs/$SHTTR_PACKAGE_NAME"
    if [[ ! -e shttr.conf ]]; then
        echo "Error: shttr.conf not found for package '$SHTTR_PACKAGE_NAME'!"
        exit -2
    fi
    # Get environment variables from file
    getvars=$(cat shttr.conf | grep '=')
    eval "$getvars"
    make "$OPERATION" \
            SHTTR_PACKAGE_NAME="$SHTTR_PACKAGE_NAME" \
            SHTTR_APT_DEPENDENCIES="$SHTTR_APT_DEPENDENCIES" \
            SHTTR_BUILD_EXECUTABLE="$SHTTR_BUILD_EXECUTABLE"

}

# Argument parsing
if [[ $# -lt 1 ]]; then
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

    list | lt)
        _list
        ;;

    make-package | mp)
        _make_package "$TARGET"
        ;;

    get-debfiles | gd)
        _get_debfiles  "$TARGET"
        ;;
esac
