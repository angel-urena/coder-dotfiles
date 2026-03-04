#!/usr/bin/env bash
set -euo pipefail

# Activate mise
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# Install all tools
echo "Installing tools via mise..."
mise install

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

echo "Done!"
