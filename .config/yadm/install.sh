#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Updating homebrew bundle..."
brew bundle --global

"$SCRIPT_DIR/install-minimax.sh"

# Install TPM (Tmux Plugin Manager) and plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
	echo "Installing TPM..."
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"

# Install Catppuccin Mocha theme for bat
BAT_THEMES_DIR="$(bat --config-dir)/themes"
mkdir -p "$BAT_THEMES_DIR"
if [[ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]]; then
	echo "Installing Catppuccin Mocha theme for bat..."
	curl -fsSL -o "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" \
		"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
	bat cache --build
fi

# Set fish as the default shell
FISH_PATH="$(command -v fish)"
if [[ -n "$FISH_PATH" ]]; then
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
