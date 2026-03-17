{ pkgs, nixpkgs-stable, ... }:

{
  home.packages = with pkgs; [
    krita
    krita-plugin-gmic
    aseprite

    pavucontrol
    piano-rs
    nixpkgs-stable.guitarix
    easyeffects
  ];

  programs.onlyoffice = {
    enable = true;
  };
}
