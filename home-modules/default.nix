{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix

    ./cli
    ./programming
    ./desktop-environment

    ./tmux.nix
    ./wezterm.nix

    ./vim.nix
  ];
}
