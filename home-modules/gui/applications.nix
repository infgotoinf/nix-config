{ pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    # aseprite
    # material-maker
    # gucharmap # Cool thing to inspect fonts

    pavucontrol
    # easyeffects
    # qpwgraph

    gnome-system-monitor
    gpu-screen-recorder-gtk
    showmethekey
    # librewolf
    qbittorrent
    # rn proton-authenticator fix is only in unstable brach sadly
    unstable.proton-authenticator

    # GUI file manager
    pcmanfm
    # thunar
    # nemo
    # For the file manager to show image preview icons
    ffmpegthumbnailer
    gdk-pixbuf
    shared-mime-info
  ];

  # programs.onlyoffice = {
  #   enable = true;
  # };
}
