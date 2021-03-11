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

alias vim="nvim"
alias echo="echo -e"