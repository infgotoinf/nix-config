{ pkgs, ... }:
let
  screenshot = ["bash" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | satty -f -
    else
      flameshot gui
    fi
  ''];

  screenshot-full = ["bash" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.grim}/bin/grim - | satty -f -
    else
      flameshot gui
    fi
  ''];

  screenlock = ["bash" "-c" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      swaylock-plugin
    else
      ${pkgs.i3lock}/bin/i3lock
    fi
  ''];
in
{
  services.xremap = {
    enable = true;
    config = {
      # throttle_ms = 200;
      keymap = [
        {
          name = "Screenshot";
          remap = {
            "Win-Shift-s".launch = screenshot;
            "Win-s".launch = screenshot-full;
          };
        }
        {
          name = "Rofi";
          remap = {
            "Win-Space".launch = ["bash" "-c" "rofi -show drun"];
            "Win-Alt-Space".launch = ["bash" "-c" "rofi -show emoji"];
            # "Win-Ctrl-Alt-Space".launch = ["bash" "-c" "rofi -show nerdy"];
          };
        }
        {
          name = "Applications";
          remap = {
            # It breaks saved pages of previous session if u runed qutebrowser with rofi, so screw it lol
            # "Win-Ctrl-U".launch       = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/org.qutebrowser.qutebrowser.desktop"];
            "Win-Ctrl-R".launch = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/renoise.desktop"];
            "Win-Ctrl-K".launch = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/org.kde.krita.desktop"];
            "Win-Ctrl-B".launch = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/blender.desktop"];
            "Win-Ctrl-G".launch = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/com.dec05eba.gpu_screen_recorder.desktop"];
            "Win-M".launch = ["bash" "-c" "mpc update; wezterm start -- rmpc"];
            "Win-Ctrl-S".launch = ["bash" "-c" "${pkgs.glib}/bin/gio launch ~/.nix-profile/share/applications/one.alynx.showmethekey.desktop"];
          };
        }
        {
          name = "MPC";
          remap = {
            "Win-P".launch           = ["bash" "-c" "mpc toggle"];
            "Win-Shift-Comma".launch = ["bash" "-c" "mpc volume -5"];
            "Win-Shift-Dot".launch   = ["bash" "-c" "mpc volume +5"];
            "Win-Comma".launch       = ["bash" "-c" "mpc prev"];
            "Win-Dot".launch         = ["bash" "-c" "mpc next"];
          };
        }
        {
          name = "Volume control";
          remap = {
            "Win-Ctrl-Shift-M".launch = ["bash" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"];
            "Win-Minus".launch = ["bash" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"];
            "Win-Equal".launch = ["bash" "-c" "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"];
          };
        }
        {
          name = "Pc control";
          remap = {
            "Win-Ctrl-Shift-l".launch = screenlock;
            "Win-Ctrl-Shift-r".launch = ["bash" "-c" "reboot"];
            "Win-Ctrl-Shift-p".launch = ["bash" "-c" "poweroff"];
            "Win-Ctrl-Shift-h".launch = ["bash" "-c" "systemctl hibernate"];
          };
        }
      ];
    };
  };
}
