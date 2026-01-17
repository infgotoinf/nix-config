{ config, lib, pkgs, ... }:

{
  imports = [
    ./zoxide.nix
    ./eza.nix
    ./fzf.nix
    ./lf.nix
    ./fastfetch.nix
  ];
}
