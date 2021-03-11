function __folding_prompt {
    # Have the bash prompt automagically fold long
    # paths, like in emacs' eshell
    pwd | gawk -F '/' '{
        NFF=NF-2
        for(i=2; i<=NF; i++) {
            if (i == 2 && $i == "home") {
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
                    printf substr($i, 0, 1)"/"
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
    export PROMPT="${PROMPT_PRE_DIR}$(__folding_prompt)${PROMPT_POST_DIR}"
}

