if [[ -d "$HOME/.local/bin" && \
        ! "$PATH" == *"$HOME/.local/bin"* ]] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ $(uname) == 'Darwin' && \
        ! "$PATH" == *"$HOME/Library/Python/3.9/bin"* ]]; then
    PATH="$HOME/Library/Python/3.9/bin:$PATH"
fi
