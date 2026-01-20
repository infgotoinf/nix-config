{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix

    ./cli
    ./desktop-environment

    ./neovim.nix
    ./tmux.nix

    ./git.nix
  ];
}
