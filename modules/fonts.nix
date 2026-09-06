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
      unifont
      nur.repos.infgotoinf.UnifontExMono
      twitter-color-emoji
      times-newer-roman
    ];
  };
}
