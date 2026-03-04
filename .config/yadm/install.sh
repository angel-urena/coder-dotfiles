#!/usr/bin/env bash
set -euo pipefail

# Source Nix profile
if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Start nix-daemon if the socket is missing (containers without systemd)
if [[ ! -S /nix/var/nix/daemon-socket/socket ]]; then
	sudo /nix/var/nix/profiles/default/bin/nix-daemon &
	while [[ ! -S /nix/var/nix/daemon-socket/socket ]]; do
		sleep 0.1
	done
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEVENV_DIR="$HOME/.config/devenv"

echo "Building devenv environment..."
cd "$DEVENV_DIR"
devenv shell -- true

# Use devenv shell for all post-install steps so tools are on PATH
DEVENV_SHELL="devenv shell --"

"$SCRIPT_DIR/install-minimax.sh"

# Install TPM (Tmux Plugin Manager) and plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
	echo "Installing TPM..."
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
cd "$DEVENV_DIR"
$DEVENV_SHELL "$TPM_DIR/bin/install_plugins"

# Install Catppuccin Mocha theme for bat
BAT_THEMES_DIR="$($DEVENV_SHELL bat --config-dir)/themes"
mkdir -p "$BAT_THEMES_DIR"
if [[ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]]; then
	echo "Installing Catppuccin Mocha theme for bat..."
	curl -fsSL -o "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" \
		"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
	$DEVENV_SHELL bat cache --build
fi

# Set fish as the default shell
FISH_PATH="$DEVENV_DIR/.devenv/profile/bin/fish"
if [[ -x "$FISH_PATH" ]]; then
	if ! grep -qxF "$FISH_PATH" /etc/shells; then
		echo "Adding fish to /etc/shells..."
		echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
	fi

	if [[ "$SHELL" != "$FISH_PATH" ]]; then
		echo "Setting fish as the default shell..."
		sudo chsh -s "$FISH_PATH" "$(whoami)"
	fi
fi

echo "Done!"
