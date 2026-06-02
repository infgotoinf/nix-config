{ pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    unstable.krita
    unstable.krita-plugin-gmic
    aseprite
    kdePackages.kdenlive
    blender
    # material-maker

    # This one is stable cause I'm tired of turning on proxy to download it
    renoise
    audacity

    # piano-rs
    guitarix
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
    # librewolf
  ];

  programs.obs-studio = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
