{ hostname, pkgs, unstable, ... }:

{
  systemd.services.NetworkManager-wait-online.enable = false;

  # https://itsfoss.gitlab.io/post/how-to-boost-linux-server-internet-speed-with-tcp-bbr/
  # https://wiki.archlinux.org/title/Sysctl
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";


    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_max_syn_backlog" = 8192;
    "net.ipv4.tcp_fin_timeout" = 10;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_mtu_probing" = 1;

    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
    "net.ipv6.conf.lo.disable_ipv6" = 1;
  };

  programs.happ = {
    enable = true;
    tunMode.enable = true;
  };
  # systemd.services.happ.serviceConfig.Capabilities = [ "CAP_NET_ADMIN" ];
  systemd.services.happ.serviceConfig = {
    Capabilities = [ "CAP_NET_ADMIN" ];
    AmbientCapabilities = [ "CAP_NET_ADMIN" ];
    CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
  };

  # programs.amnezia-vpn = {
  #   enable = true;
  #   package = unstable.amnezia-vpn;
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

  # Use this if can't install a package cause of a timeout error
  # environment.variables =
  # let
  #   proxy = "socks5://84.47.150.125:1080";
  # in {
  #   http_proxy  = proxy;
  #   https_proxy = proxy;
  #   HTTP_PROXY  = proxy;
  #   HTTPS_PROXY = proxy;
  #   no_proxy    = "127.0.0.1,localhost,internal.local";
  #   NO_PROXY    = "127.0.0.1,localhost,internal.local";
  # };

  # Yanked and edited from https://github.com/Ha1kuFox/dotfiles/blob/8b193c6842ec561bce88df0dbb385acd4e271a98/modules/nixos/network.nix
  networking = {
    hostName = hostname;
	  firewall.enable = false;
	  enableIPv6 = false;
    # Uncomment this line if internet doesn't work (it bypasses all those DNS
    # encryptors I have there, exept zapret-discord-youtube)
    # nameservers = [ "8.8.8.8" "1.1.1.1" ];
    # nameservers = [ "1.1.1.1" "1.0.0.1" ];
    # proxy.default = "52.34.243.150:8080";
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
    };
  };

  # services.resolved = {
  # 	enable = true;
  # 	settings.Resolve = {
		# 	DNS = [
		# 		"1.1.1.1"
		# 		"1.0.0.1"
		# 		"9.9.9.9"
		# 	];
		# 	DNSSEC = true;
		# 	DNSOverTLS = true;
		# 	Domains = [ "~." ];
  # 	};
  # };

  # services.resolved.enable = false;

  # services.adguardhome = {
	 #  enable = true;
	 #  openFirewall = true;
	 #  port = 666;
	 #  settings = {
		#   dns = {
		# 	  bind_hosts = [ "0.0.0.0" ];
		# 	  port = 53;
		# 	  upstream_dns = [ "127.0.0.1:5353" ];
		# 	  allowed_clients = [ "127.0.0.1" "::1" ];
		#   };
		#   filtering = {
		# 	  protection_enabled = true;
		# 	  filtering_update_interval = 24;
		#   };
	 #  };
  # };

  # services.dnscrypt-proxy = {
	 #  enable = true;
	 #  settings = {
		#   listen_addresses = ["127.0.0.1:5353"];
		#   ipv6_servers = false;
		#   require_dnssec = true;
	 #  };
  # };

#   services.zapret-discord-youtube = {
#     # enable = true;
#     configName = "general(ALT3)";
#     # configName = "general (FAKE_TLS_AUTO_ALT)";
#     gameFilter = "all";
#   };
}
