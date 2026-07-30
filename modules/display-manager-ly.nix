{ system_info, pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    sway
    i3
    xinit
  ];

  environment.etc."ly/custom-sessions/sway.desktop".text = ''
    [Desktop Entry]
    Name=Sway
    Exec=${pkgs.sway}/bin/sway --unsupported-gpu
    Type=Application
  '';

  environment.etc."ly/custom-sessions/i3.desktop".text = ''
    [Desktop Entry]
    Name=i3
    Exec=${pkgs.xinit}/bin/startx
    Type=Application
  '';

  services.displayManager.ly = {
    enable = true;
    package = unstable.ly;
    settings = {
      # doom, matrix, colormix, gameoflife
      animation = "doom";
      animation_frame_delay = 10;
      auth_fails = 3;

      battery_id = if system_info.has_battery then
        "BAT1"
      else
        null;
      clock = "%a %B %Y";
      bigclock = "en";
      #bigclock_seconds = true;
      #bigclock_12hr = true;
      #box_title = "nix-usb";
      #initial-info-text = "nix-usb";
      #text_in_center = true;

      brightness_down_key = null;
      brightness_up_key = null;
      show_password_key = null;

      clear_password = true;
      default_input = "password";
      vi_mode = true;
      vi_default_mode = "insert";

      xinitrc = null;
    };
  };
}
