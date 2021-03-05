#!/bin/bash -e

display_help() {
    cat << EOF
Portapotty - deploy script
--------------------------
An aggressively simple software (ASS) suite for keeping my shit together.
By default this script resolves dependencies from packages.yml and runs
hooks from hooks.sh for all potties, but you can tweak this behavior through
the parameters listed below.

Optional parameters:
    -h      display this help message
    -s      skip installation of dependencies for potties
    -t      run deploy logic only for target potty, specified as argument
EOF
}

while getopts "hst:"; do
    case $opt_sg in
        h) display_help ;;
        s) SKIP_DEPENDENCY_RESOLUTION=true ;;
        t) TARGET=$OPTARG ;;
        ?) echo "unknown_option: $opt_sg" ;;
    esac
done

source "./pottyfunctions.sh"

# Install packages first
install_packages_from_all_potties

if [[ -d "setup" ]]; then
    # 'setup' always has its hooks run before all other
    # potties
    echo "Running setup hooks..."
    cd ./setup
    chmod u+x ./hooks.sh
    ./hooks.sh
    cd ..
fi

while read file; do
    if [[ -d "$file" && \
            ! "$file" =~ "setup" && \
            ! "$file" =~ "exclude" ]]; then
        # If file is non-setup directory and it has hooks.sh,
        # assume it's a potty and run the hooks script
        POTTY="$file"
        echo "Running '$POTTY' hooks..."
        cd "$POTTY"
        chmod u+x ./hooks.sh
        ./hooks.sh
        cd ..
    fi
done < <(ls)
