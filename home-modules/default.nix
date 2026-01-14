{ config, lib, pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./zsh.nix
  ];
}
