{ pkgs, ... }:
{
  imports = [
    ./email.nix
  ];

  # i3.enable = true;
  sway.enable = true;

  drawing.enable = true;
  # music-production.enable = true;
  # modeling.enable = true;
  # video-editing.enable = true;

  # discord.enable = true;
  # vesktop.enable = true;

  # targets.genericLinux = {
  #   enable = true;
  #   gpu.enable = true;
  # };

  # home.file.".config/nix/nix.conf".text = ''
  #   experimental-features = nix-command flakes
  # '';

  services.xremap = {
    deviceNames = [
      "AT Translated Set 2 keyboard"
      "ThinkPad Extra Buttons"
      "Video Bus"
    ];
    config.keymap = [
      {
        name = "Thinkpad specific";
        remap = {
          "Win-Ctrl-Shift-M".launch = ["bash" "-c" "${pkgs.alsa-utils}/bin/amixer sset 'Master',0 toggle"];
          "KEY_MUTE".launch         = ["bash" "-c" "${pkgs.alsa-utils}/bin/amixer sset 'Master',0 toggle"];
        };
      }
    ];
  };
}
