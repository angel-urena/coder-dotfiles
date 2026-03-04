#!/usr/bin/env bash
set -euo pipefail

# Add brew to PATH (needed on re-runs and after fresh install)
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# install homebrew if it's missing
if ! command -v brew >/dev/null 2>&1; then
	echo "Installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add brew to PATH after fresh install
	if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	elif [[ -f /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi

echo "Installing yadm via homebrew..."
brew install yadm

echo "Cloning and bootstrapping dotfiles repository..."
if yadm status >/dev/null 2>&1; then
	echo "yadm repo already exists, pulling latest and running bootstrap..."
	yadm pull
	yadm bootstrap
else
	yadm clone --bootstrap https://github.com/angel-urena/coder-dotfiles.git
fi
