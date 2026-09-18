{
  networking.networkmanager.ensureProfiles.profiles."pc-laptop" = {
    connection = {
      id = "pc-laptop";
      type = "ethernet";
      interface-name = "enp34s0";
      autoconnect = "true";
    };
    ipv4 = {
      method = "shared";
    };
    ipv6 = {
      method = "disabled";
    };
  };
}
