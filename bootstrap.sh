#!/usr/bin/env bash
set -euo pipefail

# Install mise
if ! command -v mise >/dev/null 2>&1; then
	echo "Installing mise..."
	curl https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"

# Install yadm and fish via apt
for pkg in yadm fish; do
	if ! command -v "$pkg" >/dev/null 2>&1; then
		echo "Installing $pkg..."
		sudo apt-get update -qq && sudo apt-get install -y -qq "$pkg"
	fi
done

echo "Cloning and bootstrapping dotfiles repository..."
if yadm status >/dev/null 2>&1; then
	echo "yadm repo already exists, pulling latest and running bootstrap..."
	yadm pull
	yadm bootstrap
else
	yadm clone --bootstrap https://github.com/angel-urena/coder-dotfiles.git
fi
