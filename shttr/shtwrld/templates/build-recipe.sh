#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE=""  # TODO add the git repo URL here
    local REPO_DIR="repo"
    local SHTTR_DIR=$PWD

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi

    # TODO add instructions for building the project here
    make $MAKEOPTS
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
