{ pkgs, lib, config, ... }: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    targets.kmscon.fonts.enable = false;
    fonts = {
      monospace = {
        package = pkgs.unifont_upper;
        name = "Unifont Upper";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.adwaita-mono;
        name = "AdwaitaMono Nerd Font";
      };
      sizes.applications = 12;
      sizes.desktop = 12;
    };
    /*icons = {
      enable = true;
      dark = "Gruvbox Dark";
      package = pkgs.gruvbox-plus-icons;
    };*/
    polarity = "dark";
  };
}
