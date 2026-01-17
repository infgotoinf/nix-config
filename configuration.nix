# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  #kmscon.enable = true;

  services.zapret-discord-youtube = {
    enable = true;
    config = "general(ALT7)";  # https://github.com/kartavkun/zapret-discord-youtube/tree/main/configs
  };

  systemd.services.NetworkManager-wait-online.enable = false;
 
  services.journald.extraConfig = ''
    Storage=volotile
    RateLimitInterval=30s
    SystemMaxUse=16M
  '';

  hardware = {
    graphics = {
      enable = true;
      #enable32Bit = true;
    };
    nvidia = {
      # open = true;
      # TODO: add PRIME configuration for laptop
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      timeout = 0; # Mash space to select different deneration
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  zramSwap.enable = true; # All default options are great

  networking.hostName = "nix-usb"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Configure keymap in X11
  # In this configuration you use <Shift+Caps Lock> to switch between us and ru layouts
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:shift_caps_toggle";
  #services.xserver.videoDrivers = [ "nvidia" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = ./etc/Unifont-APL8x16-17.0.03.psf.gz;
    earlySetup = true;
    useXkbConfig = true; # use xkb.options in tty.
  };


  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.zsh.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.inf = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  #programs.firefox.enable = true;
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      # Set `Ctrl+F9' to increase display brightness
      { keys = [ 29 67 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/light -U 2"; }
      # Set `Ctrl+F10' to decrease display brightness
      { keys = [ 29 68 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/light -A 2"; }
      
      # Set 'Shift+F9' to volume up
      { keys = [ 42 67 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 1+ unmute"; }
      # Set 'Shift+F10' to volume down
      { keys = [ 42 68 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 1- unmute"; }
      
      # Set 'Ctrl+F8' to mute sound
      { keys = [ 29 66 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle"; }
      # Set 'Shift+F8' to mute mic
      { keys = [ 42 66 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Capture toggle"; }
    ];
  };

  services.tor = {
    enable = true;
    openFirewall = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    git

    w3m
    tor-browser
    nyxt
    nur.repos.vieb-nix.vieb

    htop
    btop
  
    wezterm

    #discord

    ngrrram
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 3d --keep 5 --optimise";
    };
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

