#!/bin/bash

# Ensure user bin exists
USER_BIN="$HOME/.local/bin"
if [[ ! -d "$USER_BIN" ]]; then
	mkdir -p "$USER_BIN"
fi

# Ensure portapotty state tracking directory exists
PORTAPOTTY_TRACKING_DIR="$HOME/.local/share/portapotty"
if [[ ! -d "$PORTAPOTTY_TRACKING_DIR" ]]; then
	mkdir -p "$PORTAPOTTY_TRACKING_DIR"
fi
