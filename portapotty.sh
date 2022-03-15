#!/bin/bash -e
#                            __                 __  __
#             ___  ___  ____/ /____  ___  ___  / /_/ /___ __
#            / _ \/ _ \/ __/ __/ _ `/ _ \/ _ \/ __/ __/ // /
#           / .__/\___/_/  \__/\_,_/ .__/\___/\__/\__/\_, /
#          /_/                    /_/                /___/
#
#   "...because Ansible is bloat for single desktop provisioning"
#
#  GOTOs (you can jump to these through your editor's 'find next')
#  g1. Helper function definitions
#  g2. User argument parsing
#  g3. Main deploy logic

display_help() {
    cat << EOF

Portapotty - deploy script
--------------------------
An aggressively simple software (ASS) suite for keeping my shit together.
By default this script resolves dependencies from packages.yml and runs
hooks from hooks.sh for all subdirectories, but you can tweak this behavior through
the parameters listed below.

Optional parameters:
    -i           install packages from packages.yml files
    -h           display this help message
    -q           pass QUICK_DEPLOY flag to hooks.sh scripts to skip redundant work
    -e {potty}   install {potty} from 'extra' profile by name
    -s           skip all halting messages

EOF
}

## g1. Helper definitions
_install_packages_recursively() {
    local DISTRO="$1"
    local ROOTDIR="$2"
    if [[ $USER_DISTRO == debian ]]; then
        PKG_CMD="sudo apt install -y"
    elif [[ $USER_DISTRO == opensuse ]]; then
        PKG_CMD="sudo zypper in"
    elif [[ $USER_DISTRO == macos ]]; then
        PKG_CMD="brew install"
    fi

    local PACKAGES=""
    while read packagefile; do
        for package in $(find_packages "$DISTRO" "$packagefile"); do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done
    done < <(find $ROOTDIR | grep 'packages.yml')
    if [[ ! -z "$PACKAGES" ]]; then
        NAME=$(basename $ROOTDIR)
        UNDERLINE=$(echo $NAME | awk '{ gsub(/./, "-"); print }')
        echo
        echo "The following packages for '$NAME' will be installed:"
        echo "$UNDERLINE------------------------------------------------"
        echo "$PACKAGES"
        echo
        $PKG_CMD $PACKAGES
    fi
}

find_packages() {
    local USER_DISTRO="$1"
    local PACKAGE_LISTING_YAML="$2"

    if [[ "$USER_DISTRO" == "macos" ]]; then
        local current_os="macos"
    else
        local current_os="linux"
    fi
    local packages=""
    local distro=NONE
    # ultra-simple YAML parsing that only goes one layer deep
    while read line; do
        if [[ $line =~ ((' '|\t)*\-) && ($distro == all \
                                             || $distro == $current_os \
                                             || $distro == $USER_DISTRO) ]]; then
            package=$(echo -n "$line" | awk '{ print $2 }')
            packages+=" $package"
        else
            distro=$(echo -n "$line" | awk '{ print substr($1, 1, length($1)-1) }')
        fi
    done < "$PACKAGE_LISTING_YAML"
    printf "$packages"
}

run_hooks_for_potty() {
    # If file is non-setup directory and it has hooks.sh,
    # assume it's a potty and run the hooks script
    POTTY="$1"
    cd "$POTTY"
    if [[ -e hooks.sh ]]; then
        echo "Running '$POTTY' hooks..."
        . hooks.sh
    fi
    cd ..
}

run_hooks_for_profile_if_exists() {
    PROFILE="$1"
    if [[ -d "$PROFILE" ]]; then
        if [[ $INSTALL_PACKAGES == true ]]; then
            install_packages_recursively "$PROFILE"
        fi
        cd "$PROFILE"
        while read file; do
            if [[ -d "$file" ]]; then
                run_hooks_for_potty "$file"
            fi
        done < <(ls)
        cd ..
    fi
}

ensure_dir_exists() {
    DIRPATH="$1"
    if [[ ! -d "$DIRPATH" ]]; then
        mkdir -p "$DIRPATH"
    fi
}

link_config_soft() {
    # same as link_config, but backs off if the file exists instead of bulldozing
    # it -- potentially useful for files that user applications write to
    if [[ "$SRC" == "$PWD"* ]]; then
        local SRC="$1"
    else
        local SRC="$PWD/$1"
    fi
    local DST="$(echo "$2" | awk '{ home=ENVIRON["HOME"]; gsub(/~/, home); print }')"
    if [[ ! -e "$DST" ]]; then
        ln -s "$SRC" "$DST"
    fi
}

link_config() {
    if [[ "$SRC" == "$PWD"* ]]; then
        local SRC="$1"
    else
        local SRC="$PWD/$1"
    fi
    local DST="$(echo "$2" | awk '{ home=ENVIRON["HOME"]; gsub(/~/, home); print }')"
    # new behavior - bulldoze anything that exists in place of the symlink we want
    if [[ -e "$DST" || -L "$DST" ]]; then
        rm "$DST"
    fi
    ln -s "$SRC" "$DST"
}

halting_message() {
    if [[ ! $SKIP_HALTING_MESSAGES == true ]]; then
        echo ""
        echo "[Execution paused]"
        echo "$1"
        echo "Press [Enter] to continue..."
        read -u 1
    fi
}

## g2. Argument parsing
TARGET=all
INSTALL_PACKAGES=false
QUICK_DEPLOY=false
SKIP_HALTING_MESSAGES=false

while getopts "iqhse:" opt_sg; do
    case $opt_sg in
        i) INSTALL_PACKAGES=true ;;
        q) QUICK_DEPLOY=true ;;
        h) display_help && exit 0 ;;
        s) SKIP_HALTING_MESSAGES=true ;;
        e) TARGET="$OPTARG" ;;
        ?) echo "unknown_option: $opt_sg" ;;
    esac
done

## g3. Main deploy logic
UNAME=$(uname | tr '[:upper:]' '[:lower:]')
if [[ $UNAME == linux ]]; then
    # we're running linux -- determine specific distro
    DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
    if [[ "$DISTRO_LONGNAME" == *"Debian"* || "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
        USER_DISTRO="debian"
    elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
        USER_DISTRO="opensuse"
    fi
elif [[ $UNAME == "darwin" ]]; then
    # we're running macOS
    USER_DISTRO="macos"
else
    echo "Unsupported operating system!"
    exit -1
fi

install_packages_recursively() {
    _install_packages_recursively $USER_DISTRO "$1"
}

# 'setup' always has its hooks run before any other potties
if [[ -d setup ]]; then
    run_hooks_for_potty setup
fi

if [[ "$TARGET" == all ]]; then
    # base profile hooks run on both linux and macOS
    run_hooks_for_profile_if_exists base

    # linux profile hooks only run on linux
    if [[ $UNAME == linux ]]; then
        run_hooks_for_profile_if_exists linux

    # I don't actually do anything with a macOS-only profile (yet)
    elif [[ $UNAME == darwin ]]; then
        run_hooks_for_profile_if_exists macos
    fi
else
    # install a single potty from the 'extra' profile
    if ! [ -d extra ] && find extra -maxdepth 1 | grep "$TARGET" 1>/dev/null 2>&1; then
        echo "Error: cannot find $TARGET in 'extra' profile."
        exit -1
    fi

    # run hooks for target if we find it in a profile
    cd extra/$TARGET_PROFILE
    if [[ $INSTALL_PACKAGES == true ]]; then
        install_packages_recursively "$TARGET"
    fi
    run_hooks_for_potty "$TARGET"
    cd ../..
fi
