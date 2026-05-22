{ pkgs, nixpkgs-stable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    nixpkgs-stable.krita
    nixpkgs-stable.krita-plugin-gmic
    aseprite
    kdePackages.kdenlive
    blender
    # material-maker

    renoise
    audacity
    carla

    piano-rs
    nixpkgs-stable.guitarix
    # nixpkgs-stable.surge
    surge-xt
    bespokesynth-with-vst2
    distrho-ports
    zam-plugins
    dexed
    zynaddsubfx
    geonkick
    carla
    # redux
    cardinal
    vcv-rack
    distrho-ports

    pavucontrol
    easyeffects
    qpwgraph

    qbittorrent

    docker-client
    docker-buildx
    docker-compose

    altair

    gnome-system-monitor
  ];

  programs.obs-studio = {
    enable = true;
  };

  programs.docker-cli = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
