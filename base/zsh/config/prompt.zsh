__virtualenv() {
    test ! -z "$VIRTUAL_ENV" && printf "("$(basename "$VIRTUAL_ENV")") "
}

__folding_prompt() {
    # Have the bash/zsh prompt automagically fold long
    # paths, like in emacs' eshell. works better with
    # zsh due to strange history scrollback bug in
    # bash.
    pwd | awk -F '/' '{
        NFF=NF-2
        for(i=2; i<=NF; i++) {
            if (i == 2 && ($i == "home" || $i == "Users")) {
                if (NF == 3) {
                    printf "~"
                } else {
                    printf "~/"
                }   
                i++
            } else if (i == NF) {
                printf $i
            } else {
                if (NF > 4 && i < NFF) {
                    if (substr($i, 0, 1) == ".") {
                        printf substr($i, 0, 2)"/"
                    } else {
                        printf substr($i, 0, 1)"/"
                    }
                } else {
                    printf $i"/"
                }
            }
        }
        printf "\n"
    }'
}

precmd() {
    PROMPT_PRE_DIR='%(?.%F{green}%?.%F{red}%?)%f %F{cyan}'
    PROMPT_POST_DIR='%f %# '
    export PROMPT="$(__virtualenv)${PROMPT_PRE_DIR}$(__folding_prompt)${PROMPT_POST_DIR}"
    if [[ $INSIDE_EMACS = 'vterm' ]]; then
        export PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
    else
        export PROMPT=$PROMPT
    fi
}

