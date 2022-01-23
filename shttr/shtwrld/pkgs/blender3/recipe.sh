#!/usr/bin/env bash
set -euo pipefail

shttr_build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="https://git.blender.org/blender.git"
    local SVN_LIB_REMOTE="https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64"
    local REPO_DIR="blender-git"
    local LIBRARY_DIR="lib"
    local BUILD_TAG="blender-v3.0-release"

    if [[ ! -d "$REPO_DIR" ]]; then
        mkdir "$REPO_DIR"
    fi

    cd "$REPO_DIR"

    if [[ ! -d "$LIBRARY_DIR" ]]; then
        mkdir "$LIBRARY_DIR"
        cd "$LIBRARY_DIR"
        svn checkout "$SVN_LIB_REMOTE"
        cd ..
    fi
    if [[ ! -d blender ]]; then
        git clone "$GIT_REMOTE" blender
    fi

    cd blender
    git checkout "$BUILD_TAG"
    make update
    make $MAKEOPTS
}

# resolve dependencies
if [[ "$SHTTR_APT_DEPENDENCIES" == "build-dep" ]]; then
    sudo apt build-dep "$SHTTR_APP_NAME"
elif [[ ! -z "$SHTTR_APT_DEPENDENCIES" ]]; then
    #sudo apt install $SHTTR_APT_DEPENDENCIES
    cat /dev/null
fi

# build
shttr_build
