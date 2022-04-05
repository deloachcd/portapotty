repid() {
	REGEX_ARG="$1"
	echo "$(ps -ax | grep -E "$REGEX_ARG" | head -n 1 | awk '{ print $1 }')"
}

rekill() {
	# Kill first process matched by regex string argument
	REGEX_ARG="$1"
	LINE=$(ps -ax | grep -E "$REGEX_ARG" | head -n 1)
	PID=$(echo $LINE | awk '{ print $1 }')
	NAME="$(echo $LINE | awk '{ print $5 }')"
	echo "Process \"$NAME\" with pid $PID will be killed. Continue? (y/n)"
	read -n 1 USER_WANTS_TO_KILL
	if [[ "$USER_WANTS_TO_KILL" == "y" || "$USER_WANTS_TO_KILL" == "Y" ]]; then
		kill $PID && printf "\nProcess successfully killed.\n"
	else
		printf "\nAborting.\n"
	fi
}

isoflash() {
	if="$1"
	of="$2"
	sudo dd bs=4M if="$if" \
		of="$of" conv=fdatasync status=progress
}

mkscript() {
    FILES="$@"
    for file in $FILES; do
        cat >> $file << EOF
#!/bin/bash

# dynamically include 'magic spells' mini debug library if constant defined
MAGIC_SPELLS_DEBUG_LIB=1 
if [[ ! -z "\$MAGIC_SPELLS_DEBUG_LIB" ]]; then
    source \$HOME/.config/bash/magic-spells.sh
fi
EOF
    done
}

alias tmux="tmux -2"

count() {
    i=1
    while [[ $i -lt $(($1+1)) ]]; do
        printf "$i..."
        sleep 1
        i=$((i+1))
    done
    echo "Done!"
}

scrollfix() {
    sudo modprobe -r psmouse
    count 5
    sudo modprobe psmouse
}

keyjp() {
    clear && python3 ~/Scripts/keyjp.py
}

synlink() {
    # this function clears the directory that syntastic looks in for C++ headers, and creates
    # new links to the items in the directory that its run from. this is the simplest solution I
    # can think of to multiple C++ projects which may require syntastic to look at different
    # header files, without having to duplicate a ton of data. just link to the one you're
    # working on
    setopt localoptions rmstarsilent
    SYNTASTIC_HEADERS_DIR=~/.local/include/syntastic-headers
    if [[ ! -e $SYNTASTIC_HEADERS_DIR ]]; then
        mkdir -p $SYNTASTIC_HEADERS_DIR
    fi
    rm -rf $SYNTASTIC_HEADERS_DIR/* 2>/dev/null
    # C++ dependencies are a special kind of hell, so there's no way for this not to be a monolith
    while read target; do
        if [[ "$target" == "gl3w" ]]; then
            SRC="$PWD/$target/include/GL"
            DST="$SYNTASTIC_HEADERS_DIR/GL"
        elif [[ "$target" == "glfw" ]]; then
            SRC="$PWD/$target/include/GLFW"
            DST="$SYNTASTIC_HEADERS_DIR/GLFW"
        elif [[ "$target" == "glm" ]]; then
            SRC="$PWD/$target/glm"
            DST="$SYNTASTIC_HEADERS_DIR/glm"
        else
            SRC="$PWD/$target"
            DST="$SYNTASTIC_HEADERS_DIR/$target"
        fi
        ln -s $SRC $DST
        echo "$SRC -> $DST"
    done < <(ls)
}

# This provides the vim/emacs concept of 'marks', except 
# for directories instead of for lines of text.
#
# It should be self-evident how useful this is.
dmark() {
    export USER_MARKED_DIRECTORY="$PWD"
}

dget() {
    printf "$USER_MARKED_DIRECTORY"
}

dreturn() {
    cd "$USER_MARKED_DIRECTORY"
}
alias dm="dmark"
alias dg="dget"
alias dr="dreturn"

alias echo="echo -e"
alias mirrorget="wget --mirror --convert-links --backup-converted --adjust-extension"

alias ls="ls --color"
alias gmacs="gccemacs"
