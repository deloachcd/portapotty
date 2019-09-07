#!/bin/bash

BASH_CONFIG_DIR="$HOME/.config/bash"
if [[ ! -e "$BASH_CONFIG_DIR" ]]; then
	mkdir -p "$BASH_CONFIG_DIR"
fi

# Copy primary bash dotfiles to home directory
cp -r "$PWD/dotfiles/bash/*" "$BASH_CONFIG_DIR"

# Copy shell-agnostic profile to home directory
cp "$PWD/dotfiles/profile" "$HOME/.profile"

# Link ~/.bashrc to our deployed bash init logic
cat > "$HOME/.bashrc" << EOF
#!/bin/bash

source "$BASH_CONFIG_DIR/init.sh"
EOF
