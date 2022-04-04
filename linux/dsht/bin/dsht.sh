#!/bin/bash
set -eo pipefail

# get distro first so we know which package manager to call
DSHT_HOME=$HOME/.local/share/dsht
DISTRO=$(cat /etc/os-release | grep -E '^ID=' | awk -F '=' '{ print $2 }')
if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
    DISTRO='debian'
    PKG_MANAGER='apt'
    PKG_SEARCH='apt-cache show'
elif [[ "$DISTRO" == "fedora" ]]; then
    PKG_MANAGER='dnf'
    PKG_SEARCH='dnf list'
fi

display_help() {
    cat << EOF

dsht - dandified shttr, the ASS build helper
--------------------------------------------
An aggressively simple software (ASS) tool for managing build automation.
It allows an easy to understand framework (provided you know bash) for
scripting out build instructions for projects on github/gitlab/etc, and
installing them where they can be executed in the user's home directory.

Operations:
    help, -h, --help)
        Display this help message.

    build, bd)
        Build a package listed in ${DSHT_HOME}

    install, in)
        Install a package built in ${DSHT_HOME}~/.local/share/dsht

    uninstall, un)
        Uninstall a package listed in ${DSHT_HOME}

    list, lt)
        List packages in ${DSHT_HOME}, and if they're installed

    make-package, mp)
        Create a new package listing in ${DSHT_HOME}

    get-pkgfiles, gp)
        Download and unpack package manager's file listing to get .desktop files
        and icons which can aid in quicker package creation.

EOF
}

_get_pkgfiles() {
    local TARGET="$1"
    if [[ $DISTRO == 'debian' ]]; then
        apt download "$TARGET"
        dpkg --extract $TARGET*.deb ${TARGET}_pkgfiles
        rm $TARGET*.deb
    elif [[ $DISTRO == 'fedora' ]]; then
        mkdir ${TARGET}_pkgfiles
        cd ${TARGET}_pkgfiles
        dnf download "$TARGET"
        rpm2cpio ${TARGET}*.rpm | cpio -idmv
        rm ${TARGET}*.rpm
        cd ..
    fi
}

_make_package() {
    local SHTTR_PACKAGE_NAME="$1"
    # Create directory for package listing
    echo "Creating package listing for '$SHTTR_PACKAGE_NAME' in '$DSHT_HOME/pkgs'"
    mkdir "$DSHT_HOME/pkgs/$SHTTR_PACKAGE_NAME"
    cd "$DSHT_HOME/pkgs/$SHTTR_PACKAGE_NAME"

    # Copy over initial template
    cp $DSHT_HOME/templates/recipe.sh .

    # Check if package exists in distro's repos, to look for desktop files/icons there
    if $(eval $PKG_SEARCH $SHTTR_PACKAGE_NAME 1>/dev/null 2>&1); then
        # Package exists in repos, pull archive and look for anything useful
        echo "Package exists in apt, pulling .deb archive to look for desktop files and icons"
        _get_pkgfiles "${SHTTR_PACKAGE_NAME}"
        cd ${SHTTR_PACKAGE_NAME}_pkgfiles

        # Pull desktop files (or write generic template)
        if [[ -e usr/share/applications/${SHTTR_PACKAGE_NAME}.desktop ]]; then
            echo "Hit ${SHTTR_PACKAGE_NAME}.desktop, copying it"
            mv usr/share/applications/${SHTTR_PACKAGE_NAME}.desktop \
                ../${SHTTR_PACKAGE_NAME}.desktop
        elif [[ -d usr/share/applications/ ]]; then
            echo "Hit /usr/share/applications directory, copying as applications/"
            mv usr/share/applications ..
        else
            echo "Couldn't find any desktop files, copying generic template as ${SHTTR_PACKAGE_NAME}.desktop"
            cp ../../../templates/default.desktop ../${SHTTR_PACKAGE_NAME}.desktop
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
        rm -r ${SHTTR_PACKAGE_NAME}_pkgfiles
    else
        echo "Couldn't find any desktop files, copying generic template as default.desktop"
        cp ../../templates/default.desktop .
        echo "Couldn't find any pixmaps, copying generic 256x256 icon into pixmaps/"
        mkdir pixmaps
        cp ../../templates/shttr.png pixmaps/shttr.png
    fi
}

_list() {
    for entry in $(ls $DSHT_HOME/pkgs | grep -vi templates); do
        printf "$entry"
        if [[ -e ~/.local/bin/$entry ]]; then
            printf " [installed]"
        fi
        echo
    done
}

install_pkg_manager_dependencies() {
    if [[ ! -z "$SHTTR_BUILD_DEP" ]]; then
        # NOTE: this may grow into more lines if package managers
        # are added that don't share this syntax
        sudo $PKG_MANAGER build-dep "$SHTTR_PACKAGE_NAME"
    fi
    if [[ $DISTRO == 'debian' && ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
        sudo apt install $SHTTR_APT_DEPENDENCIES
    elif [[ $DISTRO == 'fedora' && ! -z "$SHTTR_DNF_DEPENDENCIES" ]]; then
        sudo dnf install $SHTTR_DNF_DEPENDENCIES
    fi
}

__call_recipe() {
    local SHTTR_PACKAGE_NAME="$1"
    local OPERATION="$2"

    if [[ -z "$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: nothing to $OPERATION!"
        exit 1
    elif [[ ! -d "$DSHT_HOME/pkgs/$SHTTR_PACKAGE_NAME" ]]; then
        echo "Error: package '$SHTTR_PACKAGE_NAME' not found!"
        exit 1
    fi

    cd "$DSHT_HOME/pkgs/$SHTTR_PACKAGE_NAME"
    source recipe.sh
    $OPERATION
}

# Argument parsing
if [[ $# -lt 1 ]]; then
    display_help
    exit 2
elif [[ "$1" == *"help"* || "-h" == "$1" ]]; then
    display_help
fi

OPERATION="$1"
TARGET="$2"

case "$OPERATION" in
    build | bd)
        __call_recipe "$TARGET" build
        ;;

    install | in)
        __call_recipe "$TARGET" install
        ;;

    uninstall | un)
        __call_recipe "$TARGET" uninstall
        ;;

    list | lt)
        _list
        ;;

    make-package | mp)
        _make_package "$TARGET"
        ;;

    get-pkgfiles | gp)
        _get_pkgfiles  "$TARGET"
        ;;
esac
