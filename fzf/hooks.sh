#!/bin/bash
source ../pottyfunctions.sh

FZF_VERSION=0.18.0
FZF_URL="https://github.com/junegunn/fzf-bin/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tgz"

wget -c "$FZF_URL" -O - | tar -xzv -C $HOME/.local/bin
