{ pkgs, config, username, ... }:

{
  imports = [
    ./stylix.nix
    ./home-modules
  ];

  # stylix.enableReleaseChecks = false;
  # home.enableNixpkgsReleaseCheck = false;

  gtk.gtk4.theme = config.gtk.theme;

  stylix.targets.gtk.extraCss = ''
    * { border-radius: 0; }
  '';

  nixpkgs.config.allowUnfree = true;

  # i3.enable = true;
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
    # portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-gtk
    #     xdg-desktop-portal-wlr
    #     xdg-desktop-portal-termfilechooser
    #     kdePackages.xdg-desktop-portal-kde
    #   ];
    #   config.common.default = "*";
    # };
    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
    mimeApps.defaultApplications = {
      "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "image/*" = "satty.desktop";
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
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
