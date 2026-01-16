{ config, lib, pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./zoxide.nix
    ./eza.nix
    ./nvim.nix
  ];
}
