#!/usr/bin/env bash
set -euo pipefail

MINIMAX_DIR="$HOME/.local/share/MiniMax"

if ! command -v nvim >/dev/null 2>&1; then
	echo "nvim not found, skipping MiniMax setup."
	exit 0
fi

echo "Installing MiniMax for nvim..."

if [[ -d "$MINIMAX_DIR" ]]; then
	echo "MiniMax already installed at $MINIMAX_DIR, skipping clone."
else
	git clone --filter=blob:none https://github.com/nvim-mini/MiniMax "$MINIMAX_DIR"
fi

# Set up config (copies config files and possibly initiates Git repository)
nvim -l "$MINIMAX_DIR/setup.lua"

# On Neovim>=0.12 press `y` to confirm installation of all listed plugins
# Wait for plugins to install (there should be no new notifications)
