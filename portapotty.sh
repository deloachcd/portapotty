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
    -h      display this help message
    -q      pass QUICK_DEPLOY flag to hooks.sh scripts to skip redundant work
    -s      skip automated installation of packages.yml dependencies
    -t      run deploy logic only for target directory, specified as argument
    -n      skip all halting messages

EOF
}

## g1. Helper definitions
install_packages_from_all_potties() {
    local DISTRO="$1"
    local PACKAGE_CMD="$2"

    local PACKAGES=""
    while read packagefile; do
        for package in $(resolve_dependencies "$DISTRO" "$packagefile"); do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done
    done < <(find . | grep 'packages.yml')
    echo "** INSTALL DEPENDENCIES **"
    sudo $PACKAGE_CMD -y $PACKAGES
}

resolve_dependencies() {
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
    POTTY="$1"
    # If file is non-setup directory and it has hooks.sh,
    # assume it's a potty and run the hooks script
    cd "$POTTY"
    if [[ -e hooks.sh ]]; then
        echo "Running '$POTTY' hooks..."
        . hooks.sh
    fi
    cd ..
}

run_hooks_for_all_potties_in_pwd() {
    while read file; do
        if [[ -d "$file" && ! "$file" == setup ]]; then
            run_hooks_for_potty "$file"
        fi
    done < <(ls)
}

ensure_dir_exists() {
    DIRPATH="$1"
    if [[ ! -d "$DIRPATH" ]]; then
        mkdir -p "$DIRPATH"
    fi
}

link_config() {
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
SKIP_DEPENDENCY_RESOLUTION=false
QUICK_DEPLOY=false
SKIP_HALTING_MESSAGES=false

while getopts "nqhst:" opt_sg; do
    case $opt_sg in
        h) display_help && exit 0 ;;
        s) SKIP_DEPENDENCY_RESOLUTION=true ;;
        t) TARGET=$OPTARG ;;
        q) QUICK_DEPLOY=true ;;
        n) SKIP_HALTING_MESSAGES=true ;;
        ?) echo "unknown_option: $opt_sg" ;;
    esac
done


## g3. Main deploy logic
UNAME=$(uname | tr '[:upper:]' '[:lower:]')
if [[ $UNAME == "linux" ]]; then
    # we're running linux -- determine specific distro
    DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
    if [[ "$DISTRO_LONGNAME" == *"Debian"* || "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
        USER_DISTRO="debian"
        PKG_CMD="apt install"
    elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
        USER_DISTRO="opensuse"
        PKG_CMD="zypper in"
    fi
elif [[ $UNAME == "darwin" ]]; then
    # we're running macOS
    USER_DISTRO="macos"
    PKG_CMD="brew install"
else
    echo "Unsupported operating system!"
    exit -1
fi

# Install packages first
if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
    install_packages_from_all_potties "$USER_DISTRO" "$PKG_CMD"
fi

# 'setup' always has its hooks run before all other potties
if [[ -d setup ]]; then
    echo "Running setup hooks..."
    run_hooks_for_potty setup
fi

run_hooks_for_all_potties_in_pwd

# 'defer' potties always have their hooks run after the ones at project root
if [[ -d defer ]]; then
    cd defer
    run_hooks_for_all_potties_in_pwd
    cd ..
fi
