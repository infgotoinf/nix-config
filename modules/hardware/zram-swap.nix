{
  # https://wiki.nixos.org/wiki/Swap
  boot.tmp = {
    useZram = true;
    zramSettings = {
      compression-algorithm = "lz4";
      fs-type = "btrfs";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    priority = 100;
  };

  # swapDevices = [{
  #   device = "/var/lib/swapfile";
  #   size = 16*1024; # 16 GiB
  # }];

  fileSystems."/".options = [ "noatime" "nodatacow" "nodatasum" ];

  systemd.oomd.enable = true;
}
