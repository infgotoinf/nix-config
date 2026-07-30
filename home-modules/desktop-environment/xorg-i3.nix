{ lib, pkgs, username, config, ... }:
let
  commonConfig = import ./tiling-window-manager-config.nix;

in {
  options = {
    i3.enable = lib.mkEnableOption ''
      Enables i3 wm environment.
    '';
  };

  config = lib.mkIf config.i3.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        startup = [
          { command = ''xsetroot -solid "${config.lib.stylix.colors.withHashtag.base00}"''; always = true; }
          { command = ''${pkgs.feh}/bin/feh --bg-fill "${config.lib.stylix.colors.withHashtag.base00}"''; always = true; }
          { command = "wezterm"; always = true; }
          { command = "xset r rate 750 25"; always = true; }
          # This fixes xremap not starting in time/not stating correctly
          { command = "systemctl --user import-environment DISPLAY XAUTHORITY"; always = true; }
          { command = "systemctl --user restart xremap"; always = true; }
        ];
      } // (commonConfig {pkgs = pkgs; config = config; lib = lib;});
    };

    # On Xorg i3 bar looks burry, but this fixes the issue
    xresources.properties = {
      "Xft.dpi" = 98; # Default is 96
    };

    home.packages = with pkgs; [
      xclip
    ];

    services.flameshot = {
      enable = true;
      settings = {
        General = let
          colors = config.lib.stylix.colors.withHashtag;
        in {
          savePath = "/home/${username}/Pictures/Screenshots";
          filenamePattern = "~%Y-%m-%d_%H:%M:%S";
          disabledTrayIcon = true;
          # showHelp = true;

          autoCloseIdleDaemon = true;
          allowMultipleGuiInstances = true;
          showStartupLaunchMessage = false;
          showDesktopNotification = false;
          showAbortNotification = false;
          showSidePanelButton = true;
          startupLaunch = false;
          # useX11LegacyScreenshot = true;
          # captureActiveMonitor = true;

          uiColor = colors.blue;
          contrastUiColor = colors.green;
          # contrastUiColor = colors.base06;
          drawColor = colors.red;
          userColors = "${colors.red}, ${colors.green}, ${colors.yellow}, ${colors.blue}, ${colors.magenta}, ${colors.cyan}";

          drawThickness = 5;
          predefinedColorPaletteLarge = true;
        };
      };
    };

    services.screen-locker = {
      enable = true;
      inactiveInterval = 7;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c ${config.lib.stylix.colors.base00}";
    };
  };
}
