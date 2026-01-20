{ pkgs, lib, config, ... }: {
  services.displayManager = {
    enable = true;
    ly = {
      enable = true;
      settings = {
        # doom, matrix, colormix, gameoflife
        animation = "doom";
	auth_fails = 5;

	battery_id = "BAT1";
	clock = "%a %B %Y";
	bigclock = "en";
	#bigclock_seconds = true;
	#bigclock_12hr = true;
	#box_title = "nix-usb";
	#initial-info-text = "nix-usb";
	#text_in_center = true;

	brightness_down_key = null;
	brightness_up_key = null;

	clear_password = true;
	default_input = "password";
	vi_mode = true;
	vi_default_mode = "insert";
	xinitrc = null;
      };
    };
    hiddenUsers = [
      "root"
    ];
  };
}
