#!/usr/bin/env bash
set -euo pipefail

MINIMAX_DIR="$HOME/.local/share/MiniMax"

if [[ ! -d "$MINIMAX_DIR" ]]; then
	echo "MiniMax not found at $MINIMAX_DIR. Run install-minimax.sh first."
	exit 1
fi

# Pull updates of MiniMax itself
git -C "$MINIMAX_DIR" pull

# Run setup script again
nvim -l "$MINIMAX_DIR/setup.lua"

# There will probably be messages about backed up files:
# 1. Examine 'MiniMax-backup' directory with conflicting files.
# 2. Recover the ones you need.
# 3. Delete the backup directory.
