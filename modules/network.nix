{ hostname, ... }:

{
  systemd.services.NetworkManager-wait-online.enable = false;

  # https://itsfoss.gitlab.io/post/how-to-boost-linux-server-internet-speed-with-tcp-bbr/
  # https://wiki.archlinux.org/title/Sysctl
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    # "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    # "net.ipv4.tcp_wmem" = "4096 65536 16777216";


    # "net.ipv4.tcp_fastopen" = 3;
    # "net.ipv4.tcp_max_syn_backlog" = 8192;
    # "net.ipv4.tcp_fin_timeout" = 10;
    # "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_mtu_probing" = 1;

    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
    "net.ipv6.conf.lo.disable_ipv6" = 1;
  };

  programs.happ = {
    enable = true;
    tunMode.enable = true;
  };
  systemd.services.happ.serviceConfig = {
    Capabilities = [ "CAP_NET_ADMIN" ];
    AmbientCapabilities = [ "CAP_NET_ADMIN" ];
    CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
  };

  # programs.amnezia-vpn = {
  #   enable = true;
  # };

  # environment.systemPackages = with pkgs; [
  #   iptables
  #   wireshark
  # ];

  # programs.wireshark = {
  #   enable = true;
  #   usbmon.enable = true;
  # };

  # services.v2raya.enable = true;

  # Yanked and edited from https://github.com/Ha1kuFox/dotfiles/blob/8b193c6842ec561bce88df0dbb385acd4e271a98/modules/nixos/network.nix
  networking = {
    hostName = hostname;
    firewall = {
      enable = false;
      # allowedUDPPorts = [
      #   53 67 # ssh ports
      # ];
      # allowedTCPPorts = [
      #   25565 # minecraft server host
      # ];
    };
    enableIPv6 = false;
    # nameservers = [ "8.8.8.8" "1.1.1.1" ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "1.1.1.1#one.one.one.one"
        "8.8.8.8#dns.google"
      ];
      # DNSOverTLS = true;
      DNSSEC = true;
      Domains = [ "~." ];
    };
  };

  # services.zapret-discord-youtube = {
  #   enable = true;
  #   configName = "general(ALT3)";
  #   # configName = "general (FAKE_TLS_AUTO_ALT)";
  #   gameFilter = "all";
  # };
}
