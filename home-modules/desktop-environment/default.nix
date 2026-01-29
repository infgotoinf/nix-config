{ config, lib, pkgs, ... }:

{
  imports = [
    ./xorg-i3.nix
    ./wayland-sway.nix
  ];
}
