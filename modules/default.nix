{ config, lib, pkgs, ... }:

{
  imports = [
    ./xorg.nix
    ./kmscon.nix
    ./stylix.nix
  ];
}
