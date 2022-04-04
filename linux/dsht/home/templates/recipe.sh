# local path to the binary the build process generates
SHTTR_BUILD_EXECUTABLE=""

# if not a zero-length string, build recipe will use 'apt build-dep' 
# to resolve build dependencies, which requires deb-src repos to be
# enabled but can greatly simplify things
SHTTR_BUILD_DEP=""

# all additional dependencies to be installed by package managers for the build process
SHTTR_APT_DEPENDENCIES=""
SHTTR_DNF_DEPENDENCIES=""

build() {
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
