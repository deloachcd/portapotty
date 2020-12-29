export BASH_CONFIG_DIR=~/.config/bash

source $BASH_CONFIG_DIR/defaults.sh
source $BASH_CONFIG_DIR/aliases.sh

# Enable vi mode
#set -o vi

if [[ -e $BASH_CONFIG_DIR/local.sh ]]; then
    source $BASH_CONFIG_DIR/local.sh
fi

# Ensure user bin is in PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
alias えぃｔ="exit"
