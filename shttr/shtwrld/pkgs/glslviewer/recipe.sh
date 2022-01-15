#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="https://github.com/patriciogonzalezvivo/glslViewer"
    local REPO_DIR="repo"

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi

    cd repo
    git submodule init
    git submodule update

    if [[ ! -d build ]]; then
        mkdir build
    fi
    cd build

    cmake ..
    make $MAKEOPTS

    cd ..
    cd ..
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
