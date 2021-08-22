npm_() {
    env PATH="$HOME/.local/bin:$PATH" ~/.local/bin/npm $@
}

pip3_() {
    env PATH="$HOME/.local/bin:$PATH" ~/.local/bin/pip3 $@
}

if [[ "$QUICK_DEPLOY" == false ]]; then
    npm_  install -g     bash-language-server
    npm_  install -g     typescript-language-server
    pip3_ install --user python-lsp-server
fi
