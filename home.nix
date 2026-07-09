{ pkgs, username, ... }:

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

  i3.enable = true;
  sway.enable = true;

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
      };
    };
    configFile = {
      "xdg-desktop-portal-termfilechooser/config" = {
        force = true;
        executable = true;
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME/downloads
          create_help_file=1
          env=TERMCMD='kitty --title filechooser'
          env=PATH="$PATH:/run/current-system/sw/bin"
          open_mode=suggested
          save_mode=last
        '';
      };
    };
  };

  home.packages = with pkgs; [
    telegram-desktop
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
