#!/bin/bash -e

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
