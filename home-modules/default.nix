{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix

    ./cli
    ./programming
    ./desktop-environment
    ./applications.nix

    ./tmux.nix
    ./wezterm.nix

    ./vim.nix
  ];
}
