#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc) platform=x11"
    local GIT_REMOTE="https://github.com/godotengine/godot.git"
    if [[ ! -d repo ]]; then
        git clone "$GIT_REMOTE" repo
    fi
    cd repo
    scons $MAKEOPTS
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
