#!/bin/bash

# Ensure user bin exists
if [[ ! -d "$HOME/.local/bin" ]]; then
	mkdir -p $HOME/.local/bin
fi
