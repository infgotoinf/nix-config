{ pkgs,  ... }:
{
  home.packages = with pkgs; [
    # supertuxkart
    # mindustry
    # cataclysm-dda
    # retroarch
    # the-powder-toy
    flatpak
    r2modman
    # It's both for Lutris and just to use
    wineWow64Packages.full
    winetricks
  ];

  # Run this if you get an error in Lutris with flathub games:
  # flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  programs.lutris = {
    enable = true;
  };

  programs.prismlauncher = {
    enable = true;
  };
}
