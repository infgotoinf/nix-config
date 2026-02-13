{
  services.xserver = {
    xkb = {
      layout = "us,ru";
      options = "grp:shift_caps_toggle";
    };
    displayManager.startx = {
      enable = true;
      generateScript = true;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
}

