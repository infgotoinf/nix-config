{ pkgs, lib, config, ... }: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts = {
      monospace = {
        name = "Unifont Upper";
        package = pkgs.unifont_upper;
      };
      sansSerif = {
        name = "AdwaitaMono Nerd Font";
        package = pkgs.nerd-fonts.adwaita-mono;
      };
      sizes.applications = 12;
      sizes.desktop = 12;
    };
    /*icons = {
      enable = true;
      dark = "Gruvbox Dark";
      package = pkgs.gruvbox-plus-icons;
    };*/
    #targets.kmscon.fonts.enable = false;
    polarity = "dark";
  };
}
