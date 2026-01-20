{ config, lib, pkgs, ... }:

{
  imports = [
    ./display-manager-ly.nix

    ./kmscon.nix

    ./stylix.nix
  ];
}
