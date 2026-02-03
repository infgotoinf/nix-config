{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix

    ./helix.nix
    ./lsp.nix
    ./debug-tools.nix
  ];
}
