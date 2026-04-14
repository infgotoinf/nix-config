{ pkgs, nixpkgs-stable, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    krita
    krita-plugin-gmic
    aseprite
    kdePackages.kdenlive

    ardour
    # reaper
    # reaper-reapack-extension
    # reaper-sws-extension
    renoise
    audacity
    # lmms

    piano-rs
    nixpkgs-stable.guitarix
    nixpkgs-stable.surge
    bespokesynth-with-vst2
    distrho-ports
    zam-plugins
    dexed
    zynaddsubfx
    geonkick
    carla
    redux

    pavucontrol
    easyeffects
    qpwgraph

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
