{ pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    # aseprite
    # material-maker
    # gucharmap

    pavucontrol
    # easyeffects
    # qpwgraph

    gnome-system-monitor
    audacity
    gpu-screen-recorder-gtk
    showmethekey
    # librewolf
    qbittorrent
    # rn proton-authenticator fix is only in unstable brach sadly
    unstable.proton-authenticator

    pcmanfm
    # thunar
    # nemo
    # For file managers to show image preview icons
    ffmpegthumbnailer
    gdk-pixbuf
    shared-mime-info
    imagemagick
  ];

  # programs.onlyoffice = {
  #   enable = true;
  # };
}
