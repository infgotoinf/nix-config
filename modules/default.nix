{ config, lib, pkgs, ... }:

{
  imports = [
    ./xorg.nix
    ./kmscon.nix
  ];
}
