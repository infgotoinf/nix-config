{ config, lib, pkgs, ... }:

{
  imports = [
    ./display-manager-ly.nix

    ./kmscon.nix

    ./shortcuts.nix
    ./locales-and-keyboard-layouts.nix

    ./drivers.nix
    ./boot-and-kernel.nix

    ./nh.nix
  ];
}
