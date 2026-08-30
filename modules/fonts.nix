{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    packages = with pkgs; [
      # google-fonts
      liberation_ttf
      # noto-fonts
    ];
  };
}
