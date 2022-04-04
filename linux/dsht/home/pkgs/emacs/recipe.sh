# local path to the binary the build process generates
SHTTR_BUILD_EXECUTABLE="build/bin/*"

# if not a zero-length string, build recipe will use package manager
# to resolve build dependencies, which can greatly simplify things
SHTTR_BUILD_DEP="yes"

# all additional dependencies to be installed by package managers for the build process
SHTTR_APT_DEPENDENCIES="libgccjit0 libgccjit-10-dev"
SHTTR_DNF_DEPENDENCIES=""

build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="git://git.savannah.gnu.org/emacs.git"
    local REPO_DIR="repo"
    local SHTTR_DIR=$PWD

    # resolves dependencies from variables above function definitions
    install_pkg_manager_dependencies

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi
    if [[ ! -d build ]]; then
        mkdir build
    fi

    cd repo
    ./autogen.sh
    ./configure --with-modules --with-native-compilation --prefix=$SHTTR_DIR/build
    make bootstrap $MAKEOPTS
    make install
}

install() {
    test ! -z "${SHTTR_BUILD_EXECUTABLE}"

    for binary in ${SHTTR_BUILD_EXECUTABLE}; do
        ln -sf ${binary} ${HOME}/.local/bin/$(basename ${binary})
    done

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
