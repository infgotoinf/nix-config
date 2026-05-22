{ hostname, ... }:

{
  systemd.services.NetworkManager-wait-online.enable = false;

  # https://itsfoss.gitlab.io/post/how-to-boost-linux-server-internet-speed-with-tcp-bbr/
  # https://wiki.archlinux.org/title/Sysctl
  # boot.kernel.sysctl = {
  #   "net.core.default_qdisc" = "fq";
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.ipv4.tcp_rmem" = "4096 87380 16777216";
  #   "net.ipv4.tcp_wmem" = "4096 65536 16777216";


  #   "net.ipv4.tcp_fastopen" = 3;
  #   "net.ipv4.tcp_max_syn_backlog" = 8192;
  #   "net.ipv4.tcp_fin_timeout" = 10;
  #   "net.ipv4.tcp_slow_start_after_idle" = 0;
  #   "net.ipv4.tcp_mtu_probing" = 1;
  # };

  networking = {
    hostName = hostname;
    # enableIPv6 = false;
    # nameservers = [
    #   "8.8.8.8"
    #   "1.1.1.1"
    # ];
    networkmanager = {
      enable = true;
    };
  };

  services.zapret-discord-youtube = {
    enable = true;
    configName = "general(ALT8)";
    listGeneral = [
      "renoise.com"
    ];
  };
}
