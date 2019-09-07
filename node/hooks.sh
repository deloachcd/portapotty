#!/bin/bash

cd ./archives

# Retrieve and extract latest node.js, removing archive afterwards
wget http://nodejs.org/dist/node-latest.tar.gz
tar -xvf "node-latest.tar.gz"
rm node-latest.tar.gz

# Figure out where node has been extracted
NODE_DIRECTORY="$(ls | grep -E 'node-v[0-9]' | head -n 1)"

# Extract, build and install
cd "$NODE_DIRECTORY"
./configure --prefix="$HOME/.local" && make install

# Clean up
rm -r "$NODE_DIRECTORY"

cd ..
