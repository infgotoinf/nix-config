{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # xremap = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf";
    hostname = "nix-ssd";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      inherit system;
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.nur.modules.nixos.default
        inputs.zapret-discord-youtube.nixosModules.default
      ];
    };
    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home.nix
        inputs.stylix.homeModules.stylix
        # inputs.xremap.homeManagerModules.default
      ];
    };
  };
}
