# local path to the binary the build process generates
SHTTR_BUILD_EXECUTABLE="blender-git/build_linux/bin/blender"

# if not a zero-length string, build recipe will use package manager
# to resolve build dependencies, which can greatly simplify things
SHTTR_BUILD_DEP=""

# all additional dependencies to be installed by package managers for the build process
SHTTR_APT_DEPENDENCIES="build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libglew-dev"
SHTTR_DNF_DEPENDENCIES=""

build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="https://git.blender.org/blender.git"
    local SVN_LIB_REMOTE="https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64"
    local REPO_DIR="blender-git"
    local LIBRARY_DIR="lib"
    local BUILD_TAG="blender-v3.0-release"

    # resolves dependencies from variables above function definitions
    install_pkg_manager_dependencies

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

install() {
    test ! -z "${SHTTR_BUILD_EXECUTABLE}"
    test -e "${SHTTR_BUILD_EXECUTABLE}"

    ln -sf ${PWD}/${SHTTR_BUILD_EXECUTABLE} ${HOME}/.local/bin/${SHTTR_PACKAGE_NAME}

    if [[ -e ${SHTTR_PACKAGE_NAME}.desktop ]]; then
        # use awk to substitute $HOME in desktop file with absolute path
        awk '{ gsub(/\$$HOME/,ENVIRON["HOME"]); print $0 }' ${SHTTR_PACKAGE_NAME}.desktop >\
            ${HOME}/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
    fi

    if [[ ! -d ${HOME}/.local/share/icons/hicolor/256x256/apps ]]; then
        mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
    fi
    cp pixmaps/* ${HOME}/.local/share/icons
    cp pixmaps/* ${HOME}/.local/share/icons/hicolor/256x256/apps/
}

uninstall() {
    rm ${HOME}/.local/share/bin/${SHTTR_PACKAGE_NAME}
    rm ${HOME}/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
}
