{
 description = "A very basic flake. You can edit username and add more hosts here.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpgs.follows = "nixpkgs";
    };
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
  };


  outputs = { nixpkgs, nixpkgs-stable, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf"; #< Here you can change username

    # https://discourse.nixos.org/t/how-to-make-one-flake-nix-for-multiple-hosts/62056
    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
          nixpkgs-stable = import nixpkgs-stable {
            inherit system;
        };
        inherit inputs system;
        inherit username;
        inherit hostname;
      };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.nur.modules.nixos.default
        inputs.zapret-discord-youtube.nixosModules.default
        inputs.musnix.nixosModules.musnix
      ];
    };
  in
  {
    nixosConfigurations = {
      # Here you can add more hosts
      nix-ssd = mkHostConfig "nix-ssd";
      nix-pc = mkHostConfig "nix-pc";
    };

    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        nixpkgs-stable = import nixpkgs-stable {
          inherit system;
        };
        inherit username;
      };
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home.nix
        inputs.stylix.homeModules.stylix
        inputs.xremap.homeManagerModules.default
      ];
    };
  };
}
