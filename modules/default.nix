{ config, lib, pkgs, ... }:

{
  imports = [
    ./display-manager-ly.nix

    ./kmscon.nix

    ./shortcuts.nix
    ./locales-keyboard-layouts.nix

    ./drivers-xserver.nix
    ./boot-kernel.nix
    ./network.nix

    ./nh.nix
  ];
}
