{ pkgs, ... }:

{
  packages = with pkgs; [
    bat
    btop
    csvlens
    delta
    diffutils
    eza
    fd
    fish
    fzf
    gh
    git
    jq
    jqp
    just
    lazygit
    mise
    neovim
    opentofu
    ripgrep
    rsync
    scooter
    sd
    starship
    television
    tlrc
    tmux
    tree
    wget
    yadm
    yazi
    yq
    zoxide
  ];
}
