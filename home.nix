{ pkgs, config, system_info, username, ... }:

{
  imports = [
    ./stylix.nix
    ./home-modules
  ];

  # stylix.enableReleaseChecks = false;
  # home.enableNixpkgsReleaseCheck = false;

  stylix.targets.gtk.extraCss = ''
    * { border-radius: 0; }
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = system_info.has_nvidia_gpu;

  programs.discord.enable = true;

  i3.enable = true;
  sway.enable = true;

  programs.vesktop = {
    enable = true;
  #   settings = {
  #     appBadge = false;
  #     arRPC = true;
  #     checkUpdates = false;
  #     customTitleBar = false;
  #     disableMinSize = true;
  #     minimizeToTray = false;
  #     tray = false;
  #     splashTheming = true;
  #     staticTitle = true;
  #     # hardwareAcceleration = true;
  #     hardwareAcceleration = false;
  #     discordBranch = "stable";
  #   };
  #   vencord = let
  #     colors = config.lib.stylix.colors.withHashtag;
  #   in {
  #     settings = {
  #       autoUpdate = false;
  #       autoUpdateNotification = false;
  #       disableMinSize = true;
  #       notifyAboutUpdates = false;
  #       plugins = {
  #         # FakeNitro = {
  #         #   enabled = true;
  #         # };
  #         MessageLogger = {
  #           enabled = true;
  #           ignoreSelf = true;
  #         };
  #       };
  #       useQuickCss = true;
  #     };
  #     extraQuickCss = ''
  #       @font-face {
  #           font-family: 'UnifontExMono';
  #           src: url(https://github.com/stgiga/UnifontEX/releases/download/16/UnifontExMono.woff) format('woff');
  #         }

  #         /* Remove every border radius */
  #         *,
  #         *::before,
  #         *::after {
  #           border-radius: 0px !important;
  #           clip-path: none !important;
  #         }

  #         /* Scrollbar */
  #         *::-webkit-scrollbar {
  #           width: 12px !important;
  #           height: 12px !important;
  #         }

  #         *::-webkit-scrollbar-track {
  #           background-color: ${colors.base00} !important;
  #           border-radius: 0px !important;
  #         }

  #         *::-webkit-scrollbar-thumb {
  #           background-color: ${colors.base03};
  #           border-radius: 0px !important;
  #           min-height: 30px !important;
  #         }

  #         *::-webkit-scrollbar-thumb:hover,
  #         *::-webkit-scrollbar-thumb:active {
  #           background-color: ${colors.base04};
  #         }

  #         /* Appli UnifontExMono font everythere except PUA icons and stuff */
  #         *:not([class*="icon"]):not([class*="fa"]):not([class*="material"]):not([class*="glyph"]) {
  #           font-family: UnifontExMono !important;
  #         }

  #         /* Make every regular text have the same size */
  #         :is(a,
  #           b,
  #           i,
  #           p,
  #           li,
  #           body,
  #           input,
  #           textarea,
  #           button,
  #           select):not([class*="icon"]):not([class*="fa"]):not([class*="material"]):not([class*="glyph"]) {
  #           font-size: 16px !important;
  #         }

  #         /* Makes bold text work if it doesn't (cause it doesn't in Github markdown)*/
  #         strong,
  #         b {
  #           font-weight: bold !important;
  #         }

  #         /********** COLOR **********/
  #         /* Change selection color */
  #         ::selection {
  #           background-color: ${colors.blue} !important;
  #         }
  #     '';
  #   };
  };

  services.udiskie.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
  };

  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
        kdePackages.xdg-desktop-portal-kde
      ];

      config = {
        sway = {
          default = [ "wlr" "gtk" "kde" "termfilechooser" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
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
    configFile = {
      # "mimeapps.list".force = true; # Do prevent failing profile activation
      "xdg-desktop-portal-termfilechooser/config" = {
        force = true;
        executable = true;
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME/downloads
          create_help_file=1
          env=TERMCMD='wezterm'
          env=PATH="$PATH:/run/current-system/sw/bin"
          open_mode=suggested
          save_mode=last
        '';
      };
    };
  };

  home.packages = with pkgs; [
    wineWow64Packages.full
    winetricks
  ];

  /*nix.nixPath = [
    "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
    "nixos-config=$HOME/nix-config/flake.nix"
  ];*/

  home.sessionVariables = {
    TERM = "xterm-256color";
    NIXOS_OZONE_WL = 1;
    # NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
