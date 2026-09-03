{
 description = "A very basic flake. You can edit username and add more hosts here.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      # url = "github:nix-community/stylix";
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    happ-nix = {
      url = "github:DaHL-gh/happ-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
    weathr.url = "github:Veirt/weathr";
  };


  outputs = { nixpkgs, nur, unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf"; #< Here you can change username
    hostnames = [
      # Here you can add more hosts
      "nix-ssd"
      "nix-pc"
    ];
    system_info = {
      has_backlight = builtins.attrNames (builtins.readDir /sys/class/backlight) != [];
      has_battery = builtins.attrNames (builtins.readDir /sys/class/power_supply) != [];
      has_amd_gpu = (builtins.readFile (
        pkgs.runCommand "amd_gpu_check" {} ''
          ${pkgs.pciutils}/bin/lspci | grep -i vga | grep -i amd > $out || true
        ''
      ) != "");
      has_nvidia_gpu = (builtins.readFile (
        pkgs.runCommand "nvidia_gpu_check" {} ''
          ${pkgs.pciutils}/bin/lspci | grep -i vga | grep -i nvidia > $out || true
        ''
      ) != "");
    };

    args = {
      unstable = import unstable {
        inherit system;
      };
      nur = import nur {};
      inherit inputs system;
      inherit username;
      inherit system_info;
    };

    pkgs = nixpkgs.legacyPackages.${system};
    # https://discourse.nixos.org/t/how-to-make-one-flake-nix-for-multiple-hosts/62056
    mkNixosConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit hostname;
      } // args;

      modules = with inputs; [
        ./configuration.nix
        nur.modules.nixos.default
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        musnix.nixosModules.musnix
        happ-nix.nixosModules.default
        zapret-discord-youtube.nixosModules.withTestTools
      ];
    };

    mkHomeConfig = hostname: inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit hostname;
      } // args;

      inherit pkgs;
      modules = with inputs; [
        ./home.nix
        stylix.homeModules.stylix
        xremap.homeManagerModules.default
        weathr.homeModules.weathr
      ];
    };
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs hostnames mkNixosConfig;
    homeConfigurations  = nixpkgs.lib.genAttrs hostnames mkHomeConfig;
  };
}
