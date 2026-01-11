{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
  };

  outputs = { nixpkgs, ... }@inputs: {
    #let
    #  system = "x86_64-linux";
    #  username = "inf";
    #  hostname = "nix-usb";
    #in {
      nixosConfigurations.nix-usb = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
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
    #};
  };
}
