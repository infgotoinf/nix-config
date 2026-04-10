{ pkgs, nixpkgs-stable, ... }:

{
  # nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    krita
    krita-plugin-gmic
    aseprite
    kdePackages.kdenlive

    zrythm
    ardour
    # reaper
    # reaper-reapack-extension
    # reaper-sws-extension
    # renoise

    pavucontrol
    piano-rs
    nixpkgs-stable.guitarix
    nixpkgs-stable.surge
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
