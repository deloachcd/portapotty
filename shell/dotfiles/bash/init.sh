# This file fills the role of emacs's init.el, but for bash,
# replacing the traditional monolithic bash config, in which
# multiple different modules are sourced from different locations
# throughout the user's filesystem.
# 
# It is referenced by having ~/.bashrc contain a single line:
# source ~/.config/bash/init.sh
export BASHDIR=~/.config/bash

if [[ -z "$(printf "$PATH" | grep "$HOME/\.local/bin")" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

. $BASHDIR/distro-defaults/debian
source $BASHDIR/aliases.sh

if [[ "$(uname -r)" =~ "Microsoft" ]]; then
    # Allow vagrant to access Windows if we're using WSL
    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
    export WHISTLE="/mnt/c/Users/Chandler DeLoach/Whistle"
    export LS_COLORS="ow=01;36;40"
fi
