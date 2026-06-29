{ pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    unstable.krita
    unstable.krita-plugin-gmic
    # aseprite
    kdePackages.kdenlive
    blender
    # material-maker

    renoise
    audacity

    # piano-rs
    guitarix
    # nixpkgs-stable.surge
    surge-xt
    # bespokesynth-with-vst2
    distrho-ports
    # zam-plugins
    # dexed
    # zynaddsubfx
    # geonkick
    # carla
    cardinal
    rubberband
    # vcv-rack

    pavucontrol
    easyeffects
    qpwgraph

    # altair

    gnome-system-monitor
    gpu-screen-recorder-gtk
    # librewolf
  ];

  programs.rtorrent = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
