# This file fills the role of emacs's init.el, but for bash,
# replacing the traditional monolithic bash config, in which
# multiple different modules are sourced from different locations
# throughout the user's filesystem.
# 
# It is referenced by having ~/.bashrc contain a single line:
# source ~/.config/bash/init.sh
export BASHDIR=~/.config/bash

. $BASHDIR/distro-defaults/debian
source $BASHDIR/aliases.sh
