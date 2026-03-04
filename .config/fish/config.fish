# Starship prompt
if command -q starship
    starship init fish | source
end

# Zoxide (smarter cd)
if command -q zoxide
    zoxide init fish | source
end

# mise (runtime version manager)
if command -q mise
    mise activate fish | source
end

# fzf key bindings + Catppuccin Mocha colors
if command -q fzf
    set -x FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"
    fzf --fish | source
end

# Aliases
if command -q eza
    alias ls "eza"
    alias ll "eza -l --git"
    alias la "eza -la --git"
    alias tree "eza --tree"
end

if command -q bat
    alias cat "bat --paging=never"
end
