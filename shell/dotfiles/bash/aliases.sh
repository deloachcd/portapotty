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

weekspay() {
    echo 'scale=2;' '26.55475' '*' "$1" '/' '1' | bc
}

myip() {
    curl --ssl https://ipv4.myip.info && echo
}

alias nim="nvim"
alias tmux="tmux -2"
alias code="codium"

if [[ "$(uname -r)" =~ "Microsoft" ]]; then
    alias cdw='cd "/mnt/c/Users/Chandler DeLoach/Whistle"'
fi

CHARTER_FUNCTIONS="$HOME/.config/bash/charter/source.sh"
if [[ -e "$CHARTER_FUNCTIONS" ]]; then
    source "$CHARTER_FUNCTIONS"
fi
