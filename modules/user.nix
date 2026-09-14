{ pkgs, username, ... }:
{
  # programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.${username} = {
    # shell = pkgs.zsh;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "uinput"
      "input"
      "jackaudio"
      "wireshark"
      "media"
    ];
  };

  nix.settings.trusted-users = [ "${username}" ];
}
