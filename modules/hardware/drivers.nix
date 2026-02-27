{ pkgs, ... }:

{
  security.pam = {
    loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
    # services.i3lock = enable;
  };

  #services.autorandr.enable = true;
  services.picom.enable = true;

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      open = true;
      # TODO: add PRIME configuration for laptop
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}

