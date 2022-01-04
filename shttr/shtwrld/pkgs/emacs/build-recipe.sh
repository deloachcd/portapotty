#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="git://git.savannah.gnu.org/emacs.git"
    local REPO_DIR="repo"
    local SHTTR_DIR=$PWD

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi
    if [[ ! -d build ]]; then
        mkdir build
    fi

    cd repo
    ./autogen.sh
    ./configure --with-modules --with-native-compilation --prefix=$SHTTR_DIR/build
    make bootstrap $MAKEOPTS
    make install
}

# resolve dependencies
if [[ ! -z "$SHTTR_BUILD_DEP" ]]; then
    sudo apt build-dep "$SHTTR_PACKAGE_NAME"
fi
if [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
