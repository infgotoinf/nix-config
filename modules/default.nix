{ config, lib, pkgs, ... }:

{
  imports = [
    ./display-manager.nix

    ./kmscon.nix

    ./stylix.nix
  ];
}
