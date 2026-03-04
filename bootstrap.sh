#!/usr/bin/env bash
set -euo pipefail

# Start nix-daemon if the socket is missing (containers without systemd)
ensure_nix_daemon() {
	if [[ ! -S /nix/var/nix/daemon-socket/socket ]]; then
		sudo /nix/var/nix/profiles/default/bin/nix-daemon &
		# Wait for the socket to appear
		while [[ ! -S /nix/var/nix/daemon-socket/socket ]]; do
			sleep 0.1
		done
	fi
}

# Source Nix profile if already installed
if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	ensure_nix_daemon
fi

# Install Nix via Determinate Systems installer (container-friendly)
if ! command -v nix >/dev/null 2>&1; then
	echo "Installing Nix..."
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
		sh -s -- install --no-confirm
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	ensure_nix_daemon
fi

# Install devenv
if ! command -v devenv >/dev/null 2>&1; then
	echo "Installing devenv..."
	nix profile install --accept-flake-config github:cachix/devenv/latest
fi

# Install yadm
if ! command -v yadm >/dev/null 2>&1; then
	echo "Installing yadm..."
	nix profile install nixpkgs#yadm
fi

echo "Cloning and bootstrapping dotfiles repository..."
if yadm status >/dev/null 2>&1; then
	echo "yadm repo already exists, pulling latest and running bootstrap..."
	yadm pull
	yadm bootstrap
else
	yadm clone --bootstrap https://github.com/angel-urena/coder-dotfiles.git
fi
