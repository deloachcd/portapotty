MSC_CYAN='\e[36m'
MSC_BLUE='\e[34m'
MSC_GREEN='\e[32m'
MSC_DEFAULT='\e[39m'
MSC_GOLD='\e[33m'

MAGICSPELL_expose() {
    LINENUM="$1"
    VARIABLES="$(echo "$@" | cut -f 2- -d ' ')"
    printf "${MSC_BLUE}(expose l.$LINENUM)\n"
    for variable in $VARIABLES; do
        echo -e "$variable -> ${!variable}"
    done
    printf "${MSC_DEFAULT}"
}

prompt_MAGICSPELL_stasis() {
    LINENUM="$1"
    printf "(stasis l.$LINENUM) [$(pwd)] -> "
}

MAGICSPELL_stasis() {
    LINENUM="$1"
    printf "$MSC_GOLD"
    prompt_MAGICSPELL_stasis $LINENUM
    while read user_command; do
        if [[ -z "$user_command" ]]; then
            break
        else
            eval "$user_command"
        fi
        prompt_MAGICSPELL_stasis $LINENUM
    done
    printf "$MSC_DEFAULT"
}

f_cast() {
    LINENUM="$1"
    SPELL="$2"
    SPELL_ARGS="$(echo "$@" | cut -f 3- -d ' ')"
    if [[ "$SPELL" == "stasis" ]]; then
        MAGICSPELL_stasis $LINENUM
    elif [[ "$SPELL" == "expose" ]]; then
        MAGICSPELL_expose $LINENUM $SPELL_ARGS
    else
        echo "Unknown spell $SPELL"
    fi
}

spells='eval f_cast $LINENO'
