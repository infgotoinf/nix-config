{
 description = "A very basic flake. You can edit username and add more hosts here.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret-discord-youtube = {
      url = "github:kartavkun/zapret-discord-youtube";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, nur, nixpkgs-stable, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf"; #< Here you can change username

    pkgs = nixpkgs.legacyPackages.${system};
    # https://discourse.nixos.org/t/how-to-make-one-flake-nix-for-multiple-hosts/62056
    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
        nixpkgs-stable = import nixpkgs-stable {
          inherit system;
        };
        nur = import nur {
          inherit system;
        };
        inherit inputs system;
        inherit username;
        inherit hostname;
      };
      modules = with inputs; [
        ./configuration.nix
        nur.modules.nixos.default
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix

        musnix.nixosModules.musnix
        zapret-discord-youtube.nixosModules.withTestTools
        (
          {pkgs, ...}:
          {
            nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];

            # Using architecure specific kernel don't really seem to change anything that much
            # lto also doesn't really change performance according to benchmarks (but compiles
            # 50% slower)
            # Amoung all default kernels 'zen' seems like the best one, so if you don't want to
            # wait chachy kernel compilation, you can use zen kernel, but you will sacrifice a
            # little bit of performance.
            # boot.kernelPackages = pkgs.linuxPackages_zen;
            # boot.kernelPackages = let
            #   kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
            #     pname = "linux-cachyos-latest-rt-bore-x86_64-v3";
            #     cpusched = "rt-bore";
            #     processorOpt = "x86_64-v3";
            #     rt = true;
            #   };
            # in
            # pkgs.linuxKernel.packagesFor kernel;
            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
            # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
            # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-rt;
          }
        )
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
        nur = import nur {
          inherit system;
        };
        inherit username pkgs;
      };
      inherit pkgs;
      modules = with inputs; [
        ./home.nix
        stylix.homeModules.stylix
        xremap.homeManagerModules.default
      ];
    };
  };
}
