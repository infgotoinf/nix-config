{ pkgs, nur, config, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts = {
      monospace = {
        name = "UnifontExMono";
        package = nur.repos.infgotoinf.UnifontExMono;

        # name = "Unifont";
        # package = pkgs.unifont;

        # name = "Unifont";
        # package = pkgs.unifont-csur;

        # name = "Unifont";
        # package = pkgs.runCommand "unifont-custom" {} ''
        #   mkdir -p $out/share/fonts
        #   cp ${./etc/fonts}/UnifontCSURNerdFontPlusFontAwesomePlusFontAwesomeExtensionPlusMaterialDesignIcons-Regular.otf $out/share/fonts/
        # '';

        # Need to fix Wezterm, to make it work
        # name = "ProggyClean Nerd Font Mono";
        # package = pkgs.nerd-fonts.proggy-clean-tt;
      };
      serif = config.stylix.fonts.monospace;
      # serif = config.stylix.fonts.sansSerif;
      sansSerif = config.stylix.fonts.monospace;
      # sansSerif = {
      #   name = "ProggyClean Nerd Font";
      #   package = pkgs.nerd-fonts.proggy-clean-tt;
      # };

      emoji = {
        name = "Twitter Color Emoji";
        package = pkgs.twitter-color-emoji;
      };
      sizes.desktop = 12;
      # sizes.desktop = 14;
      sizes.applications = config.stylix.fonts.sizes.desktop;
    };

    icons = {
      enable = true;
      dark = "Gruvbox-Plus-Dark";
      package = (pkgs.gruvbox-plus-icons.overrideAttrs (oldAttrs: {
        preInstall = ''
          rm -rf Gruvbox-Plus-*/apps/*
        '';
        })
      );
      # dark = "oomox-gruvbox-dark";
      # package = pkgs.gruvbox-dark-icons-gtk;
      # dark = "Mint-Y";
      # package = pkgs.mint-y-icons;
    };

    cursor = {
      name = "retrosmart-xcursor-black";
      package = nur.repos.infgotoinf.retrosmart-x11-cursors;
      size = config.stylix.fonts.sizes.desktop;
    };
    polarity = "dark";
  };
}
