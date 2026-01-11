{ config, lib, pkgs, ... }:

{
  imports = [
    ./xorg.nix
    ./tmux.nix
  ];
}
