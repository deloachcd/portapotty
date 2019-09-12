#!/bin/bash
source ../pottyfunctions.sh
FLAGS="$@"

VAGRANT_VERSION=2.2.5

# Check if vagrant is already installed, and install it via dpkg if not
vagrant -v 2>/dev/null 1>/dev/null
if [[ ! $? -eq 0 ]]; then
    wget https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/vagrant_${VAGRANT_VERSION}_x86_64.deb \
        -O vagrant.deb
    sudo dpkg -i vagrant.deb
    rm vagrant.deb
fi
