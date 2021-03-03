# assemble the prompt string PS1
# ripped off from: https://stackoverflow.com/a/16715681
function __build_prompt {
    local EXIT="$?" # store current exit code
    
    # start with an empty PS1
    OLD_PS1="$PS1"
    PS1=""

    if [[ $EXIT -eq 0 ]]; then
        PS1+="${FG_GREEN}√${FG_RESET} "      # Add green for success
    else
        PS1+="${FG_RED}${EXIT}${FG_RESET} " # Add red if exit code non 0
    fi
    # this is the default prompt for 
    PS1+="${BOLD_GRAY}\w ${RESET}\$ "
}

PROMPT_COMMAND=__build_prompt
