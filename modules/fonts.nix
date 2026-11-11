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
      inter
      times-newer-roman
      lato
      charis
      eb-garamond

      julia-mono
      fira-code
      unifont
      nur.repos.infgotoinf.UnifontExMono

      twitter-color-emoji
      font-awesome
    ];
  };
}
