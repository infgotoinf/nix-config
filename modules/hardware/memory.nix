{
  # https://wiki.nixos.org/wiki/Swap
  # boot.tmp = {
  #   useZram = true;
  #   zramSettings = {
  #     compression-algorithm = "lz4";
  #     fs-type = "btrfs";
  #   };
  # };

  # zramSwap = {
  #   enable = true;
  #   algorithm = "lz4";
  #   priority = 100;
  # };

  # https://btrfs.readthedocs.io/en/latest/ch-mount-options.html
  fileSystems."/".options = [ "noatime" "nodatacow" "nodatasum" ];

  systemd.oomd.enable = true;
}
