{
  boot.tmp = {
    useZram = true;
    zramSettings = {
      compression-algorithm = "lz4";
      fs-type = "btrfs";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "lz4";
    priority = 100;
  };
}
