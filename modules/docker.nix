{ username, ...}:

{
  users.users.${username} = {
    linger = true;
    autoSubUidGidRange = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        # registry-mirrors = [ "https://mirror.gcr.io" ];
      };
    };
  };
}
