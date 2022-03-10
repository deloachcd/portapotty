#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="https://github.com/deloachcd/Desmos-Desktop.git"
    local REPO_DIR="repo"

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi

    cd repo
    npm install -d
    npm run dist
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
