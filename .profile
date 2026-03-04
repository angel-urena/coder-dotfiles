# mise
if [ -f "$HOME/.local/bin/mise" ]; then
	eval "$("$HOME/.local/bin/mise" activate bash)"
fi

# Source .bashrc for interactive login shells
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
