#!/bin/bash
# portapotty deployment: 'fonts' layer
source ../pottyfunctions.sh

if [[ ! -d "$HOME/.fonts" ]]; then
    mkdir "$HOME/.fonts"
fi

deploy_dotfile "$PWD/otf/FiraCode-Regular.otf" "$HOME/.fonts/FiraCode.otf"
