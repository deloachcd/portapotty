#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="" # TODO set this
    local REPO_DIR="repo"

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi

    # TODO script out project build instructions here,
    # before the project gets made

    make $MAKEOPTS
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    sudo apt install $SHTTR_APT_DEPENDENCIES
fi

# build
shttr_build
