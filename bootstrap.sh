#!/usr/bin/env bash
set -euo pipefail

# install homebrew if it's missing
if ! command -v brew >/dev/null 2>&1; then
	echo "Installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add brew to PATH for the rest of this script
	if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	elif [[ -f /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi

echo "Installing yadm via homebrew..."
brew install yadm

echo "Cloning and bootstrapping dotfiles repository..."
yadm clone --bootstrap https://github.com/angel-urena/coder-dotfiles.git
