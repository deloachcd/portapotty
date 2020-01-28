#!/bin/bash
# portapotty deployment: 'node' layer
source ../pottyfunctions.sh

./script/install-node-lts.sh -y --prefix=$HOME/.local
