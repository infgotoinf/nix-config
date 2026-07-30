{ pkgs, config, username, ... }:

with config; {

  # gnome-boxes.enable = true;

  programs.nix-ld.enable = true;

  programs.gpu-screen-recorder = {
    enable = true;
  };

  environment.sessionVariables = {
    TERM = "xterm-256color";
    NIXOS_OZONE_WL = 1;
    # NIX_BUILD_SHELL = "${pkgs.fish}/bin/fish";
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
  ];

  security.sudo.extraConfig = ''
    Defaults pwfeedback

    Defaults use_pty
  '';

  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  # systemd.user.settings.Manager = {
  #   DefaultTimeoutStopSec = 10;
  # };
  systemd.user.extraConfig = "DefaultTimeoutStartSec=10";

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


  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      # Mirrors in case of 1984
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # Ok, they don't work in 1984
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    # packages = with pkgs; [
    #   font-awesome_6
    # ];
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.${username} = {
    # shell = pkgs.zsh;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "uinput"
      "input"
      "jackaudio"
      "wireshark"
    ];
  };

  nix.settings.trusted-users = [ "${username}" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
