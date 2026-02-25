{
  stylix.targets.qutebrowser.fonts.override = { sizes.applications = 11; };
  
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      # auto_save.session = true;
    };
  };
}
