# This file is written to be sourced from a bash shell, not
# directly executed as a script.

set_autocomplete() {
	complete -W "$(ls $LAZY_DIR)" lazy
}

lazy-add() {
	echo "$2 $3 $4 $5" > $LAZY_DIR/$1
	set_autocomplete
}

lazy-del() {
	rm $LAZY_DIR/$1
	set_autocomplete
}

lazy() {
	PLATFORM=$1
	LINE=$(cat $LAZY_DIR/$1)
	LOGIN=$(printf $LINE | awk '{ print $1 }')
	RULES=$(printf $LINE | awk '{ print $2 }')
	LENGTH=$(printf $LINE | awk '{ print $3 }')
	COUNTER=$(printf $LINE | awk '{ print $4 }')
	if [[ -z $RULES ]]; then
		lesspass -c $PLATFORM $LOGIN
	elif [[ -z $LENGTH ]]; then
		lesspass -c $PLATFORM $LOGIN -$RULES
	elif [[ -z $COUNTER ]]; then
		lesspass -c $PLATFORM $LOGIN -$RULES -L $LENGTH
	else
		lesspass -c $PLATFORM $LOGIN -$RULES -L $LENGTH -C $COUNTER
	fi
}

set_autocomplete
