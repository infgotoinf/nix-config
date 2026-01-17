{ config, lib, pkgs, ... }:

{
  imports = [
    ./xorg.nix
    ./wayland.nix
  ];
}
