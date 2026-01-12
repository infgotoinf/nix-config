{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf";
    hostname = "nix-usb";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      inherit system;
      modules = [
        ./configuration.nix
        inputs.stylix.nixosModules.stylix
        inputs.zapret-discord-youtube.nixosModules.default
        {
          services.zapret-discord-youtube = {
            enable = true;
            config = "general(ALT7)";  # https://github.com/kartavkun/zapret-discord-youtube/tree/main/configs
          };
        }
      ];
    };
    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home.nix
      ];
    };
  };
}
