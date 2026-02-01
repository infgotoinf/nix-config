{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix

    ./cli
    ./desktop-environment

    ./vim.nix
    ./helix.nix
    ./tmux.nix
    ./wezterm.nix

    ./git.nix
  ];
}
