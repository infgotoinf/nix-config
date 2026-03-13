{ pkgs, config, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts = {
      monospace = {
        name = "Unifont";
        package = pkgs.unifont;
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      /*sansSerif = {
        package = pkgs.nerd-fonts.adwaita-mono;
        name = "AdwaitaMono Nerd Font";
      };*/
      sizes.applications = 12;
      sizes.desktop = 12;
      # sizes.applications = 14;
      # sizes.desktop = 14;
    };

    icons = {
      enable = true;
      dark = "Gruvbox Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    polarity = "dark";
  };
}
