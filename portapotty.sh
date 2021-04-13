#!/bin/bash -e
#                       __                 __  __      
#        ___  ___  ____/ /____  ___  ___  / /_/ /___ __
#       / _ \/ _ \/ __/ __/ _ `/ _ \/ _ \/ __/ __/ // /
#      / .__/\___/_/  \__/\_,_/ .__/\___/\__/\__/\_, / 
#     /_/                    /_/                /___/  
# 
#  "Because bash is the best configuration management tool"
#
#  GOTOs (you can jump to these through your editor's 'find next'):
#  g1. Helper function definitions
#  g2. User argument parsing
#  g3. Main deploy logic

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

    local packages=""
    local distro=NONE
    while read line; do
        if [[ $line =~ ((' '|\t)*\-) && ($distro == all \
                || $distro == $USER_DISTRO) ]]; then
            package=$(echo -n "$line" | awk '{ print $2 }')
            packages+=" $package"
        else
            distro=$(echo -n "$line" | awk '{ print substr($1, 1, length($1)-1) }')
        fi
    done < "$PACKAGE_LISTING_YAML"
    printf "$packages"
}

deploy_dotfile() {
    local SRC="$1"
    local DST="$2"
    cp "$SRC" "$DST"
    cat >> "$HOME/.local/bin/push-up" << EOF
if [[ -e "$DST" ]] && ! diff -q "$SRC" "$DST" 1>/dev/null; then
    cp "$DST" "$SRC" && echo "$DST -> $SRC"
fi
EOF
}

ensure_dir_exists() {
    DIRPATH="$1"
    if [[ ! -d "$DIRPATH" ]]; then
        mkdir -p "$DIRPATH"
    fi
}

## g2. Argument parsing

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


## g3. Main deploy logic
source pottyfunctions.sh

# Determine which distro we're running
DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
if [[ "$DISTRO_LONGNAME" == *"Ubuntu"* ]]; then
    USER_DISTRO="ubuntu"
    PKG_CMD="apt install"
elif [[ "$DISTRO_LONGNAME" == *"openSUSE"* ]]; then
    USER_DISTRO="opensuse"
    PKG_CMD="zypper in"
elif [[ "$DISTRO_LONGNAME" == *"Arch Linux"* ]]; then
    USER_DISTRO="arch"
    PKG_CMD="pacman -S --needed"
fi

# Install packages first
if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
    install_packages_from_all_potties "$USER_DISTRO" "$PKG_CMD"
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
