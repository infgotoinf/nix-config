{ pkgs, config, username, ... }:

# let
#   proxy = "socks5://185.58.207.89:1080";
# in
with config; {
  # Use this if can't install a package
  # networking.proxy.default = proxy;
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.local";

  # environment.variables = {
  #   http_proxy  = proxy;
  #   https_proxy = proxy;
  #   HTTP_PROXY  = proxy;
  #   HTTPS_PROXY = proxy;
  #   no_proxy    = "127.0.0.1,localhost,internal.local";
  #   NO_PROXY    = "127.0.0.1,localhost,internal.local";
  # };

  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    TERM = "xterm-256color";
    NIXOS_OZONE_WL = 1;
    # NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
  };

  imports = [
    ./stylix.nix
    ./modules
  ];

  nixpkgs.config.allowUnfree = true;

  musnix = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    w3m
    zsh
  ];

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults insults

    Defaults use_pty
  '';

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
      kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = "*";
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s";

  services.journald.extraConfig = ''
    Storage=volotile
    RateLimitInterval=30s
    SystemMaxUse=16M
  '';

  # For automounting connected devices
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
  };


  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # fonts = {
  #   fontDir.enable = true;
  #   packages = with pkgs; [
  #     unifont
  #     unifont_upper
  #   ];
  # };

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.zsh.enable = true;

  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "uinput"
      "input"
      "jackaudio"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Disable the firewall.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
