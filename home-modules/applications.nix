{ pkgs, nixpkgs-stable, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-stable.krita
    nixpkgs-stable.krita-plugin-gmic
    aseprite
    libreoffice

    pavucontrol
    piano-rs
    nixpkgs-stable.guitarix
  ];
}
