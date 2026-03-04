# Source .profile if not already loaded (non-login interactive shells)
if [ -z "$__PROFILE_SOURCED" ] && [ -f "$HOME/.profile" ]; then
	export __PROFILE_SOURCED=1
	. "$HOME/.profile"
fi

# Launch fish for interactive sessions only
FISH_PATH="/usr/bin/fish"
if [ -t 1 ] && [ -x "$FISH_PATH" ] && [ -z "$FISH_LAUNCHED" ]; then
	export FISH_LAUNCHED=1
	exec "$FISH_PATH"
fi
