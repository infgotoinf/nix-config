{ pkgs,  ... }:
{
  home.packages = with pkgs; [
    # supertuxkart
    # mindustry
    # cataclysm-dda
    # the-powder-toy

    # retroarch
    # r2modman

    # Run this if you get an error in Lutris with flathub games:
    # flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak

    # It's both for Lutris and just to use
    wineWow64Packages.full
    winetricks
  ];

  programs.lutris = {
    enable = true;
  };

  # programs.prismlauncher = {
  #   enable = true;
  # };
}
