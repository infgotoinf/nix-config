{
  imports = [
    ./stylix.nix
    ./home-modules
  ];

  nixpkgs.config.allowUnfree = true;

  xorg.enable = true;
  wayland.enable = true;

  services.udiskie.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "inf";
  home.homeDirectory = "/home/inf";


  home.shellAliases = {
    cd = "z ";
    ls = "eza ";
    # rmv = "~/nix-config/etc/rmv.sh ";
    nix-zshell = "nix-shell --run zsh";
    list-all-avalible-xdg-apps = "echo $XDG_DATA_DIRS | tr -d '\n' | xargs -d : -I % find %/applications -name '*.desktop'";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "image/*" = "satty.desktop";
    };
  };

  /*nix.nixPath = [
    "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
    "nixos-config=$HOME/nix-config/flake.nix"
  ];*/ 

  home.sessionVariables = {
    TERM = "xterm-256color";
    NIXOS_OZONE_WL = 1;
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
