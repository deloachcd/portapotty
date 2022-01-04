#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="git://git.savannah.gnu.org/emacs.git"
    local REPO_DIR="repo"

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi
    if [[ ! -d $HOME/.local/share/emacs ]]; then
        mkdir $HOME/.local/share/emacs
    fi

    cd repo
    ./autogen.sh
    ./configure --prefix=$HOME/.local/share/emacs --with-native-compilation
    make bootstrap $MAKEOPTS
    make install
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
