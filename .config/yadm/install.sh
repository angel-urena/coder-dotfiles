#!/usr/bin/env bash
set -euo pipefail

# Install all tools via mise
export PATH="$HOME/.local/bin:$PATH"

# Pass GitHub token to mise to avoid rate limits
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
	export GITHUB_API_TOKEN="$GITHUB_TOKEN"
fi

echo "Installing tools via mise..."
mise trust
mise install || echo "Warning: some tools failed to install (likely rate-limited). Re-run 'mise install' later."

# Use shims so tools are available for the rest of this script
export PATH="$HOME/.local/share/mise/shims:$PATH"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/install-minimax.sh"

# Install TPM (Tmux Plugin Manager) and plugins
if command -v tmux >/dev/null 2>&1; then
	TPM_DIR="$HOME/.tmux/plugins/tpm"
	if [[ ! -d "$TPM_DIR" ]]; then
		echo "Installing TPM..."
		git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
	fi
	"$TPM_DIR/bin/install_plugins"

	# Seed tmux-resurrect save dir so continuum-restore doesn't error on first launch
	RESURRECT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
	if [[ ! -f "$RESURRECT_DIR/last" ]]; then
		mkdir -p "$RESURRECT_DIR"
		printf 'pane\t0\t0\t:*\t0\t:%s\t1\t fish\t:\t0' "$HOME" > "$RESURRECT_DIR/tmux_resurrect_seed.txt"
		ln -sf tmux_resurrect_seed.txt "$RESURRECT_DIR/last"
	fi
fi

# Install Catppuccin Mocha theme for bat
if command -v bat >/dev/null 2>&1; then
	BAT_THEMES_DIR="$(bat --config-dir)/themes"
	mkdir -p "$BAT_THEMES_DIR"
	if [[ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]]; then
		echo "Installing Catppuccin Mocha theme for bat..."
		curl -fsSL -o "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" \
			"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
		bat cache --build
	fi
fi

echo "Done!"
