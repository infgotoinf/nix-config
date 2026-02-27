{
  services.xserver = {
    xkb = {
      # 'localectl list-x11-keymap-layouts' to list all supportet layouts
      layout = "us,ru";
      # 'localectl list-x11-keymap-options | grep grp:' to list all supportet shortcuts
      options = "grp:caps_toggle"; # This one switches locales
    };
    displayManager.startx = {
      enable = true;
      generateScript = true;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
}

