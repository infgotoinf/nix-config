{ pkgs, nixpkgs-stable, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-stable.krita
    nixpkgs-stable.krita-plugin-gmic
    aseprite

    pavucontrol
    piano-rs
    nixpkgs-stable.guitarix
  ];

  programs.onlyoffice = {
    enable = true;
  };
}
