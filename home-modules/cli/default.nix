{ config, lib, pkgs, ... }:

{
  imports = [
    ./zoxide.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./lf.nix
    ./fastfetch.nix
    ./btop.nix
  ];
}
