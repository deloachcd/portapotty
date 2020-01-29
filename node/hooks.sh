#!/bin/bash
# portapotty deployment: 'node' layer
source ../pottyfunctions.sh

if ! which node; then
    ./script/install-node-lts.sh -y --prefix=$HOME/.local
fi
