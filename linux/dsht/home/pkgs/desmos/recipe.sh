# local path to the binary the build process generates
SHTTR_BUILD_EXECUTABLE="repo/dist/desmos 1.0.0.AppImage"

build() {
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

install() {
    test ! -z "${SHTTR_BUILD_EXECUTABLE}"
    test -e "${SHTTR_BUILD_EXECUTABLE}"

    ln -sf "${PWD}/${SHTTR_BUILD_EXECUTABLE}" ${HOME}/.local/bin/${SHTTR_PACKAGE_NAME}

    if [[ -e ${SHTTR_PACKAGE_NAME}.desktop ]]; then
        # use awk to substitute $HOME in desktop file with absolute path
        awk '{ gsub(/\$HOME/,ENVIRON["HOME"]); print $0 }' ${SHTTR_PACKAGE_NAME}.desktop >\
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
