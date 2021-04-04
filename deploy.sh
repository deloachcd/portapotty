#!/bin/bash -e

display_help() {
    cat << EOF

Portapotty - deploy script
--------------------------
An aggressively simple software (ASS) suite for keeping my shit together.
By default this script resolves dependencies from packages.yml and runs
hooks from hooks.sh for all potties, but you can tweak this behavior through
the parameters listed below.

Optional parameters:
    -h      display this help message
    -q      pass QUICK_DEPLOY flag to hooks.sh scripts to skip redundant work
    -s      skip automated installation of packages.yml dependencies
    -t      run deploy logic only for target potty, specified as argument

EOF
}

TARGET=all
SKIP_DEPENDENCY_RESOLUTION=false
QUICK_DEPLOY=false

while getopts "qhst:" opt_sg; do
    case $opt_sg in
        h) display_help && exit 0 ;;
        s) SKIP_DEPENDENCY_RESOLUTION=true ;;
        t) TARGET=$OPTARG ;;
        q) QUICK_DEPLOY=true ;;
        ?) echo "unknown_option: $opt_sg" ;;
    esac
done

source pottyfunctions.sh

# Determine which distro we're running
DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
if [[ "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
    USER_DISTRO="ubuntu"
elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
    USER_DISTRO="opensuse"
elif [[ "$DISTRO_LONGNAME" == *"Arch Linux"* ]]; then
    USER_DISTRO="arch"
fi

# Install packages first
if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
    install_packages_from_all_potties "$USER_DISTRO"
fi

if [[ -d setup ]]; then
    # 'setup' always has its hooks run before all other
    # potties
    echo "Running setup hooks..."
    cd setup
    . hooks.sh
    cd ..
fi

while read file; do
    if [[ -d "$file" && \
            ! "$file" == setup && \
            ! "$file" == exclude ]]; then
        # If file is non-setup directory and it has hooks.sh,
        # assume it's a potty and run the hooks script
        POTTY="$file"
        echo "Running '$POTTY' hooks..."
        cd "$POTTY"
        if [[ -e hooks.sh ]]; then
            . hooks.sh
        fi
        cd ..
    fi
done < <(ls)
