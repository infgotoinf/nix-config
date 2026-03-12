{ pkgs, ... }:

{
  imports = [
    ./stylix.nix
    ./modules
  ];

  nixpkgs.config.allowUnfree = true;

  #kmscon.enable = true;

  musnix = {
    enable = true;
  };

  services.zapret-discord-youtube = {
    enable = true;
    configName = "general(ALT7)";  # https://github.com/kartavkun/zapret-discord-youtube/tree/main/configs
  };

  # virtualisation.docker = {
  #   enable = true;
  #   storageDriver = "btrfs";
  #   rootless = {
  #     enable = true;
  #     setSocketVariable = true;
  #   };
  # };

  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s";

  powerManagement.cpuFreqGovernor = "performance"; 

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

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "lz4";
    priority = 100;
  };

  services.irqbalance.enable = true;


  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      unifont
      unifont_upper
    ];
  };

  console = {
    font = ./etc/fonts/Unifont-APL8x16-17.0.03.psf.gz;
    # font = "Lat2-Terminus16";
    earlySetup = true;
    useXkbConfig = true; # use xkb.options in tty.
  };
                  
  environment.variables = { 
    TERM = "xterm-256color";
  };


  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.zsh.enable = true;

  hardware.uinput.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.inf = {
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
      "docker"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    git

    w3m

    htop-vim
  ];

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

