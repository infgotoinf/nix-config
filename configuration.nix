{ pkgs, config, username, ... }:

with config; {
  services = {
    tor = {
      enable = true;
      enableGeoIP = false;
      openFirewall = true;
      torsocks.enable = true;

      client = {
        enable = true;
        dns.enable = true;
      };

      settings = {
        AvoidDiskWrites = 1;
        HardwareAccel = 1;
        SafeLogging = 1;

        DNSPort = [{
          addr = "127.0.0.1";
          port = 9053;
        }];

        # UseBridges = true;
        # ClientTranportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
        # Bridge = "obfs4
        # Bridges = [
        #   "obfs4 83.229.15.208:65535 D3E98BA2555DCA5B7FA2E105167DAE4CF393533A cert=AyNLa6xlRzu+k18pwUA/g5M2IrSMETyysvj6zv/mnbfxeY1QHUH7tI7NVXicGWd3f/Yufg iat-mode=0"
        #   "obfs4 148.113.173.182:9443 D710A86E8AAE84737FCBBCB2CF0A7903583941CA cert=hjS2leB9TM1aMsQL+gvqazR5W/Rkm+oq/tGHKzeZeWlJIJFWYTCcx//fy09+By+fGNstXA iat-mode=0"
        # ];
      };
    };

    resolved = {
      enable = true;
      settings.Resolve.FallbackDNS = [ "1.1.1.1" "9.9.9.9" ];
    };
  };

  # networking.nameservers = [ "127.0.0.1" ];
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  programs.nix-ld.enable = true;

  # services.privoxy = {
  #   enable = true;
  #   settings = {
  #     listen-address = "192.168.1.10:8118";
  #     forward-socks5 = "/ 127.0.0.1:9050 .";
  #   };
  # };

  # systemd.services.nix-daemon.serviceConfig.Environment = [
  #   "http_proxy=http://192.168.1.10:8118"
  #   "https_proxy=http://192.168.1.10:8118"
  #   "no_proxy=127.0.0.1,localhost,internal.local"
  # ];

  # networking.proxy.default = "http://192.168.1.10:8118";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.local";

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

  services.zapret-discord-youtube = {
    enable = true;
    configName = "general(ALT7)";  # https://github.com/kartavkun/zapret-discord-youtube/tree/main/configs
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
