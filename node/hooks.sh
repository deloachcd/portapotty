if [[ ! -e ~/.local/bin/node ]] ; then
    ./script/install-node-lts.sh -y --prefix=$HOME/.local
fi
