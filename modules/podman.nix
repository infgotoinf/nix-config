{ pkgs, username, ...}:
{
  users.users.${username} = {
    extraGroups = [
      "podman"
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    docker-language-server
  ];
}
