{ pkgs, username, ... }:

{
  imports = [
    ./stylix.nix
    ./home-modules
  ];

  nixpkgs.config.allowUnfree = true;

  # xorg.enable = true;
  wayland.enable = true;

  services.udiskie.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";


  home.shellAliases = {
    cd = "z ";
    ls = "eza ";
    # rmv = "~/nix-config/etc/rmv.sh ";
    nix-zshell = "nix-shell --run zsh";
    xdg-list-avalible-apps = "echo $XDG_DATA_DIRS | tr -d '\n' | xargs -d : -I % find %/applications -name '*.desktop'";
    btrfs-balance = "sudo btrfs balance start -dusage=10 -musage=10 /";
    btrfs-defrag = "sudo btrfs filesystem defragment -r / 2&> /dev/null";
    dd-measure-disk-write-speed = "dd if=/dev/zero of=/tmp/lol.img bs=1G count=1 oflag=dsync; rm -rf /tmp/lol.img";
  };

  home.sessionVariables = {
    BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
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

  home.packages = with pkgs; [
    telegram-desktop
  ];

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
