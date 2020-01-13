export BASH_CONFIG_DIR=~/.config/bash

source $BASH_CONFIG_DIR/defaults.sh
source $BASH_CONFIG_DIR/aliases.sh

if [[ -e $BASH_CONFIG_DIR/local.sh ]]; then
    source $BASH_CONFIG_DIR/local.sh
fi

# Ensure user bin is in PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
