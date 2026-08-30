{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # aseprite
    # material-maker

    pavucontrol
    # easyeffects
    # qpwgraph

    gnome-system-monitor
    gpu-screen-recorder-gtk
    # librewolf
    qbittorrent
    pcmanfm
    # thunar
    # nemo
    ffmpegthumbnailer
    gdk-pixbuf
    shared-mime-info
    imagemagick
  ];

  # programs.rtorrent = {
  #   enable = true;
  # };

  programs.onlyoffice = {
    enable = true;
  };
}
