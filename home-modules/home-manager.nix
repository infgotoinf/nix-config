{ username, ... }:
{
  stylix.enableReleaseChecks = false;
  home.enableNixpkgsReleaseCheck = false;

  # nix.nixPath = [
  #   "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
  #   "nixos-config=$HOME/nix-config/flake.nix"
  # ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.username = username;
  home.homeDirectory = "/home/${username}";
}
