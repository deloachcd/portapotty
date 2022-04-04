# local path to the binary the build process generates
SHTTR_BUILD_EXECUTABLE="repo/build/glslViewer"

# if not a zero-length string, build recipe will use package manager
# to resolve build dependencies, which can greatly simplify things
SHTTR_BUILD_DEP=""

# all additional dependencies to be installed by package managers for the build process
SHTTR_APT_DEPENDENCIES="git cmake xorg-dev libglu1-mesa-dev ffmpeg libavcodec-dev libavcodec-extra libavfilter-dev libavfilter-extra libavdevice-dev libavformat-dev libavutil-dev libswscale-dev libv4l-dev libjpeg-dev libpng-dev libtiff-dev"
SHTTR_DNF_DEPENDENCIES="git gcc-c++ cmake mesa-libGLU-devel libXi-devel libXxf86vm-devel libXdamage-devel libatomic"

build() {
    local MAKEOPTS="-j$(nproc)"
    local GIT_REMOTE="https://github.com/patriciogonzalezvivo/glslViewer"
    local REPO_DIR="repo"

    # resolves dependencies from variables above function definitions
    install_pkg_manager_dependencies

    if [[ ! -d "$REPO_DIR" ]]; then
        git clone "$GIT_REMOTE" "$REPO_DIR"
    fi

    cd repo
    git submodule init
    git submodule update

    if [[ ! -d build ]]; then
        mkdir build
    fi
    cd build

    cmake ..
    make $MAKEOPTS

    cd ../..
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
