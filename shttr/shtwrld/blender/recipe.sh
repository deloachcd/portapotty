#!/usr/bin/env bash

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="" # TODO add this

    # you probably want this to be named 'repo'
    git clone "$GIT_REMOTE" repo

    # TODO script out project build instructions here,
    # before the project gets made

    # usually, MAKEOPTS will just be -j$(nproc)
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
