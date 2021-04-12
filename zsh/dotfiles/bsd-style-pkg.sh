BSDPKG_help() {
    local DISTRO="$1"
    shift
    local MODE="$1"
    case $MODE in 
        (install | in) BSDPKG_install_package $USER_DISTRO "help" ;;
        (delete | de) BSDPKG_delete_package $USER_DISTRO "help" ;;
        (remove | rm) BSDPKG_remove_package $USER_DISTRO "help" ;;
        (update | up) BSDPKG_update_packages $USER_DISTRO "help" ;;
        (refresh | re) BSDPKG_refresh_packages $USER_DISTRO "help" ;;
        (search | se) BSDPKG_search_remote_packages $USER_DISTRO "help" ;;
        (query | qe) BSDPKG_query_local_packages $USER_DISTRO "help" ;;
        (info | if) BSDPKG_info_package $USER_DISTRO "help" ;;
        *)
            echo "--- BSD style package manager script ---"
            echo "This is my solution to different Linux distro's package managers having different"
            echo "ways of doing the same thing (and not liking pacman's syntax). Note that it"
            echo "is 'BSD-style' only in the sense that the syntax is similar - it adds commands"
            echo "(e.g. 'remove') and has slightly different behavior (e.g. 'update' automatically"
            echo "upgrades, with 'refresh' acting more like BSD's 'update'). Additionally, not all"
            echo "BSD 'pkg' commands are implemented, so this is in no way a substitute for learning"
            echo "your distro's package manager."
            echo
            echo "--- Usage ---"
            echo "      pkg install|in  <options>  <pkg>"
            echo "      pkg refresh|re  <options>  <pkg>"
            echo "      pkg  delete|de  <options>  <pkg>"
            echo "      pkg  remove|rm  <options>  <pkg>"
            echo "      pkg  update|up  <options>  <pkg>"
            echo "      pkg  search|se  <options>  <pkg>"
            echo "      pkg   query|qe  <options>  <pkg>"
            echo "      pkg    info|if  <options>  <pkg>"
            echo
            echo "--- Further detail ---"
            echo "You can type 'pkg help <command>' to get more info on a command, and see the"
            echo "underlying call to your package manager it resolves to."
            ;;
    esac
}

BSDPKG_refresh_packages() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch) CMD='sudo pacman -Sy $@' ;;
        (ubuntu) CMD='sudo apt update $@' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- refresh / re --"
        echo "Refresh package information from remote repositories."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}

BSDPKG_update_packages() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch) CMD='sudo pacman -Syu $@' ;;
        (ubuntu) CMD='sudo apt update $@ && sudo apt upgrade -y' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- update / up --"
        echo "Update packages from remote repositories."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}

BSDPKG_delete_package() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch) CMD='sudo pacman -R $@' ;;
        (ubuntu) CMD='sudo apt remove $@' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- delete / de --"
        echo "Delete packages without removing their automatically installed dependencies."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
        case $DISTRO in
            ubuntu)
                printf "NOTE:\n"
                printf "Dependencies for the deleted package will be automatically "
                printf "removed the next time \`sudo apt autoremove\` is run.\n"
                echo
                printf "Use \`sudo apt-mark manual <package>\` to prevent this for packages "
                printf "you still want.\n"
        esac
    fi
}

BSDPKG_remove_package() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch) CMD='sudo pacman -Rs $@' ;;
        (ubuntu) CMD='sudo apt remove $@ && sudo apt autoremove -y' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- remove / rm --"
        echo "Delete packages and remove their automatically installed dependencies."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}

BSDPKG_info_package() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch) CMD='pacman -Si $@' ;;
        (ubuntu) CMD='apt show $@' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- info / if --"
        echo "Get information on a remote package."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}

BSDPKG_query_local_packages() {
    local DISTRO="$1"
    shift
    local SEARCH_STRING="$1"
    shift
    case $DISTRO in
        (arch) CMD='pacman -Qs $SEARCH_STRING $@' ;;
        # Redirect to get rid of "apt doesn't have a stable interface" warning
        (ubuntu) CMD='apt list --installed $@ 2>/dev/null | egrep "$SEARCH_STRING"' ;;
    esac
    if [[ "$SEARCH_STRING" == "help" ]]; then
        echo "-- query / qe --"
        echo "Query locally installed packages for names matching string argument."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}


BSDPKG_search_remote_packages() {
    local DISTRO="$1"
    shift
    local SEARCH_STRING="$1"
    shift
    case $DISTRO in
        (arch) CMD='pacman -Ss $SEARCH_STRING $@' ;;
        (ubuntu) CMD='apt search $SEARCH_STRING $@' ;;
    esac
    if [[ "$SEARCH_STRING" == "help" ]]; then
        echo "-- search / se --"
        echo "Search remote packages for names matching string argument."
        echo "\`$CMD\` is the underlying command."
    else
        eval $CMD
    fi
}

BSDPKG_install_package() {
    local DISTRO="$1"
    shift
    case $DISTRO in
        (arch)
            LOCAL_PKG_CMD='sudo pacman -U $@'
            REMOTE_PKG_CMD='sudo pacman -S --needed $@'
            if [[ "$1" == *".pkg.tar"* ]]; then
                CMD="$LOCAL_PKG_CMD"
            else
                CMD="$REMOTE_PKG_CMD"
            fi
            ;;
        (ubuntu) CMD='sudo apt install $@' ;;
    esac
    if [[ "$@" == "help" ]]; then
        echo "-- install / in --"
        echo "Install packages from remote repositories or tarballs."
        case $DISTRO in
            arch)
                echo "\`$REMOTE_PKG_CMD\` is the underlying command for remote install."
                echo "\`$LOCAL_PKG_CMD\` is the underlying command for local install."
                ;;
            *)
                echo "\`$CMD\` is the underlying command."
                ;;
        esac
    else
        eval $CMD
    fi
}

pkg() {
    # Figure out what distro we're running, so we can figure out package manager commands
    local DISTRO_LONGNAME="$(cat /etc/os-release | egrep '^NAME' | awk -F '"' '{ print $2 }')"
    local USER_DISTRO
    case "$DISTRO_LONGNAME" in
        *"Ubuntu"*) USER_DISTRO="ubuntu" ;;
        *"Arch Linux"*) USER_DISTRO="arch";;
    esac

    local MODE="$1"
    shift

    case $MODE in 
        (install | in) BSDPKG_install_package $USER_DISTRO $@ ;;
        (delete | de) BSDPKG_delete_package $USER_DISTRO $@ ;;
        (remove | rm) BSDPKG_remove_package $USER_DISTRO $@ ;;
        (update | up) BSDPKG_update_packages $USER_DISTRO $@ ;;
        (refresh | re) BSDPKG_refresh_packages $USER_DISTRO $@ ;;
        (search | se) BSDPKG_search_remote_packages $USER_DISTRO $@ ;;
        (query | qe) BSDPKG_query_local_packages $USER_DISTRO $@ ;;
        (info | if) BSDPKG_info_package $USER_DISTRO $@ ;;
        (help | --help | h | -h) BSDPKG_help $USER_DISTRO $@ ;;
        *)
            echo "\`$MODE\` is not a known command for the BSD-style package manager script."
            ;;
    esac
}
