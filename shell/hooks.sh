#!/bin/bash
source ../pottyfunctions.sh

BASH_CONFIG_DIR="$HOME/.config/bash"
if [[ ! -e "$BASH_CONFIG_DIR" ]]; then
	mkdir -p "$BASH_CONFIG_DIR"
fi

# Copy primary bash dotfiles to home directory
deploy_dotfile "$PWD/dotfiles/profile" "$BASH_CONFIG_DIR"
if [[ ! -e "$BASH_CONFIG_DIR/bash" ]]; then
    mkdir "$BASH_CONFIG_DIR/bash"
fi
deploy_dotfile "$PWD/dotfiles/bash/init.sh" \
    "$BASH_CONFIG_DIR/bash/init.sh"
deploy_dotfile "$PWD/dotfiles/bash/aliases.sh" \
    "$BASH_CONFIG_DIR/bash/aliases.sh"
if [[ ! -e "$BASH_CONFIG_DIR/bash/distro-defaults" ]]; then
    mkdir "$BASH_CONFIG_DIR/bash/distro-defaults"
fi
cp "$PWD/dotfiles/bash/distro-defaults/debian" \
    "$BASH_CONFIG_DIR/bash/distro-defaults/debian"

# Copy shell-agnostic profile to home directory
cp "$PWD/dotfiles/profile" "$HOME/.profile"

# Link ~/.bashrc to our deployed bash init logic
cat > "$HOME/.bashrc" << EOF
#!/bin/bash
source "$BASH_CONFIG_DIR/init.sh"
EOF
