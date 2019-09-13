#!/bin/bash
source ../pottyfunctions.sh
FLAGS="$@"

NODE_VERSION="v10.16.3"
NODE_DIRECTORY="node-$NODE_VERSION-linux-x64"
NODE_ARCHIVE="$NODE_DIRECTORY.tar.xz"
NODE_URL="https://nodejs.org/dist/$NODE_VERSION/$NODE_ARCHIVE"

if  [[ "$FLAGS" =~ "full" ]]; then
    # Get stable release of node.js
    wget "$NODE_URL"                               # Creates NODE_ARCHIVE 
    tar -xvf "$NODE_ARCHIVE" && rm "$NODE_ARCHIVE" # Creates NODE_DIRECTORY

    # Install node files into user's local installation directory
    cp $NODE_DIRECTORY/bin/* "$HOME/.local/bin"
    cp -r $NODE_DIRECTORY/lib/* "$HOME/.local/lib"
    cp -r $NODE_DIRECTORY/share/* "$HOME/.local/share"
    cp -r $NODE_DIRECTORY/include/* "$HOME/.local/include"

    # Clean up
    rm -r "$NODE_DIRECTORY"
fi
