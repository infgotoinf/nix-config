{ pkgs, ... }:

{
  home.packages = with pkgs; [
    krita
    krita-plugin-gmic
    libreoffice

    piano-rs
  ];
}
