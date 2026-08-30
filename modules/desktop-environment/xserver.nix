{
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    displayManager.startx = {
      enable = true;
      extraCommands = ''
        exec i3
      '';
    };
  };

  security.pam.services.i3lock = {};
}
