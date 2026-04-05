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

    qbittorrent

    docker-client
    docker-buildx
    docker-compose
  ];

  programs.docker-cli = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
