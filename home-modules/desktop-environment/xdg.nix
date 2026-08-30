{ pkgs, config, ... }:
{
  qt = {
    enable = true;
    qt5ctSettings = {
      Appearance = {
        # icon_theme = "Gruvbox-Plus-Dark"; # Doesn't change anything
        standard_dialogs = "xdgdesktopportal";
      };
    };
    qt6ctSettings = config.qt.qt5ctSettings;
    platformTheme.name = "gtk3";
  };

  home.sessionVariables = {
    BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";

    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  xdg = {
    enable = true;
    portal = {
      enable = true;
      # Don't replace with configPackages
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        # xdg-desktop-portal-termfilechooser
        # kdePackages.xdg-desktop-portal-kde
      ];

      # TODO: maybe make some better filechooser
      config = {
        sway = {
          # default = [ "wlr" "gtk" "termfilechooser" ];
          default = [ "gtk" ];
          # "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };
    };
    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "pcmanfm.desktop";

        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";

        "application/pdf" = "onlyoffice-desktopeditors.desktop";
        "image/gif" = "org.qutebrowser.qutebrowser.desktop";
        # And yes for some reason wildcards (image/*) don't work
        "image/png" = "satty.desktop";
        "image/jpg" = "satty.desktop";
        "image/webp" = "satty.desktop";
        "image/svg+xml" = "satty.desktop";

        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";

        "audio/mp3" = "mpv.desktop";
      };
    };
    # configFile = {
    #   # "mimeapps.list".force = true; # Do prevent failing profile activation
    #   "xdg-desktop-portal-termfilechooser/config" = {
    #     force = true;
    #     executable = true;
    #     text = ''
    #       [filechooser]
    #       cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    #       default_dir=$HOME/Downloads
    #       create_help_file=1
    #       env=TERMCMD='wezterm start --always-new-process'
    #       env=PATH="$PATH:/run/current-system/sw/bin"
    #       open_mode=suggested
    #       save_mode=last
    #     '';
    #   };
    # };
  };
}
