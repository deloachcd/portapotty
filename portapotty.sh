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
        for package in $(resolve_dependencies "$DISTRO" "$packagefile"); do
            PACKAGES="$(eval printf "$package") $PACKAGES"
        done
    done < <(find $ROOTDIR | grep 'packages.yml')
    if [[ ! -z "$PACKAGES" ]]; then
        echo "** Installing packages for '$(basename $PWD)' ***"
        $PACKAGE_CMD $PACKAGES
    fi
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
    # If file is non-setup directory and it has hooks.sh,
    # assume it's a potty and run the hooks script
    cd "$1"
    if [[ -e hooks.sh ]]; then
        echo "Running '$POTTY' hooks..."
        . hooks.sh
    fi
    cd ..
}

run_hooks_for_profile_if_exists() {
    PROFILE="$1"
    if [[ -d "$PROFILE" ]]; then
        if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
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

init_unpopulated_submodules() {
    # ensure all submodules are checked out if they don't exist
    RETURN_DIR="$PWD"
    MODULE_COUNT=0
    FIRST_RUN=
    while read submodule_path; do
        cd $submodule_path
        if [[ $MODULE_COUNT -eq 0 && ! -e .git ]]; then
            FIRST_RUN=true
            git submodule init
            git submodule update
        fi
        if [[ $FIRST_RUN ]]; then
            git checkout master
            git pull
        fi
        cd "$RETURN_DIR"
    done < <(cat .gitmodules | grep '\s*path =' | awk '{ print $3 }')
}

find_containing_profile() {
    CONTAINING_PROFILE=
    if [ -d base ] && ls base | grep "$TARGET" 1>/dev/null; then
        CONTAINING_PROFILE=base
    elif [ -d extra ] && ls extra | grep "$TARGET" 1>/dev/null; then
        CONTAINING_PROFILE=extra
    elif [ -d linux ] && ls linux | grep "$TARGET" 1>/dev/null; then
        CONTAINING_PROFILE=linux
    elif [ -d macos ] && ls macos | grep "$TARGET" 1>/dev/null; then
        CONTAINING_PROFILE=macos
    fi

    printf $CONTAINING_PROFILE
}
        TARGET_PROFILE=macos

## g2. Argument parsing

TARGET=all
SKIP_DEPENDENCY_RESOLUTION=false
QUICK_DEPLOY=false
SKIP_HALTING_MESSAGES=false

while getopts "nqhst:" opt_sg; do
    case $opt_sg in
        h) display_help && exit 0 ;;
        s) SKIP_DEPENDENCY_RESOLUTION=true ;;
        t) TARGET="$OPTARG" ;;
        q) QUICK_DEPLOY=true ;;
        n) SKIP_HALTING_MESSAGES=true ;;
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

# Install packages first
if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
    install_packages_from_all_potties "$USER_DISTRO" "$PKG_CMD"
fi

# Next, set up submodules from root dir
init_unpopulated_submodules

# 'setup' always has its hooks run before any other potties
if [[ -d setup ]]; then
    echo "Running setup hooks..."
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
    # find which profile our target is in (or error if we don't find it)
    TARGET_PROFILE=$(find_containing_profile)
    if [[ -z $TARGET_PROFILE ]]; then
        echo "Error: could not find '$TARGET' in any profile"
        exit -1
    fi

    # run hooks for target if we find it in a profile
    cd $TARGET_PROFILE
    if [[ $SKIP_DEPENDENCY_RESOLUTION == false ]]; then
        install_packages_recursively "$TARGET"
    fi
    run_hooks_for_potty "$TARGET"
    cd ..
fi
