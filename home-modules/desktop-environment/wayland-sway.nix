{ lib, pkgs, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;

in {
  options = {
    sway.enable = lib.mkEnableOption ''
      Enables sway wm environment.
    '';
  };

  config = lib.mkIf config.sway.enable {
    wayland = {
      windowManager.sway = {
        enable = true;
        systemd.variables = ["--all"];
        config = {
          input."*" = {
            # modules/keyboard/locales-keyboard-layouts.nix
            xkb_layout = "us,ru";
            xkb_options = "grp:caps_toggle";
            repeat_delay = "750";
            repeat_rate = "25";
          };
          startup = [
            # { command = ''${pkgs.swaybg}/bin/swaybg -c "${config.lib.stylix.colors.withHashtag.base00}"''; always = true; }
            { command = "${pkgs.windowtolayer}/bin/windowtolayer alacritty -e weathr"; always = true; }
            { command = "wezterm"; always = true; }
            # { # swayidle is here. The reason is that if you use a systemd service it fails to start
            #   # and then you have to import enviroment into it to make it work, and this also doesn't
            #   # work like meh, this is easier.
            #   # command = "swayidle -w timeout 7 'swaylock-plugin' \
            #   #                        timeout 12 'swaymsg \"output * power off\"' \
            #   #                        resume 'swaymsg \"output * power on\"'";
            #   command = ''bash -lc "${pkgs.swayidle}/bin/swayidle -w \
            #                   timeout ''$((7*60)) 'swaylock-plugin' \
            #                   timeout ''$((12*60)) 'swaymsg \"output * power off\"' \
            #                   resume 'swaymsg \"output * power on\"'"
            #             '';
            #   always = true;
            # }
            { command = "systemctl --user import-environment SWAYSOCK WAYLAND_DISPLAY XDG_RUNTIME_DIR"; always = true; }
            { command = "systemctl --user restart xremap"; always = true; }
          ];
        } // (commonConfig {pkgs = pkgs; config = config; lib = lib;});
      };
    };

    home.packages = with pkgs; [
      # brightnessctl
      wl-clipboard
    ];

    programs.alacritty = {
      enable = true;
      settings.window.padding = {
        x = config.stylix.fonts.sizes.desktop;
        y = config.stylix.fonts.sizes.desktop;
      };
    };

    programs.satty = {
      enable = true;
      settings = {
        general = {
          floating-hack = true;
          corner-roundness = 0;
          resize.mode = "smart";
          initial-tool = "brush";
          output-filename = "~/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png";
        };
        color-palette = {
          palette = let
            colors = config.lib.stylix.colors.withHashtag;
          in [
            colors.red
            colors.green
            colors.yellow
            colors.blue
            colors.magenta
            colors.cyan
          ];
        };
      };
    };

    programs.weathr = {
      enable = true;
      package = pkgs.weathr;
      settings = {
        location = {
          auto = true;
          display = "city";
        };
      };
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-plugin;
      settings = let
        mkf = lib.mkForce;
        colors = config.lib.stylix.colors;
      in {
        indicator-radius = 150;
        indicator-thickness = 20;
        ignore-empty-password = true;
        disable-caps-lock-text = true;
        indicator-idle-visible = false;
        daemonize = true;

        inside-color        = mkf "00000000";
        inside-wrong-color  = mkf "00000000";
        inside-clear-color  = mkf "00000000";
        inside-ver-color    = mkf "00000000";
        layout-bg-color     = mkf "00000000";
        layout-border-color = mkf "00000000";
        ring-color          = mkf "00000000";
        bs-hl-color         = mkf colors.magenta;
        ring-clear-color    = mkf colors.magenta;
        ring-ver-color      = mkf colors.yellow;

        command-each = "${pkgs.windowtolayer}/bin/windowtolayer alacritty -e weathr";
      };
    };
  };
}
