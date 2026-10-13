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
      times-newer-roman
      lato

      twitter-color-emoji
      font-awesome
    ];
  };
}
