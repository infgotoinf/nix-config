{ pkgs, username, ...}:
{
  users.users.${username} = {
    linger = true;
    autoSubUidGidRange = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    # package = stable.docker;
    rootless = {
      enable = true;
      setSocketVariable = true;
      # package = stable.docker;
      daemon.settings = {
        # dns = [ "1.1.1.1" "8.8.8.8" ];
        registry-mirrors = [
          "https://mirror.gcr.io"
          "https://dockerproxy.com"
        ];
        # To not get timeouts if internet slow
        max-concurrent-downloads = 1;
        max-concurrent-uploads = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-buildx
    docker-client
    docker-compose
    docker-color-output
    docker-language-server
  ];
}
