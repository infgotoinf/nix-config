{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix

    ./cli
    ./desktop-environment

    ./neovim-nvf.nix
    ./tmux.nix

    ./git.nix
  ];
}
