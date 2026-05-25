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

    # This one is stable cause I'm tired of turning on proxy to download it
    nixpkgs-stable.renoise
    audacity

    # piano-rs
    nixpkgs-stable.guitarix
    # nixpkgs-stable.surge
    surge-xt
    # bespokesynth-with-vst2
    distrho-ports
    zam-plugins
    # dexed
    # zynaddsubfx
    # geonkick
    # carla
    cardinal
    # vcv-rack

    pavucontrol
    easyeffects
    qpwgraph

    qbittorrent

    altair

    gnome-system-monitor
    gpu-screen-recorder-gtk
    librewolf
  ];

  programs.obs-studio = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
