{
 description = "A very basic flake. You can edit username and add more hosts here.";

  inputs = {
    ultrastable.url = "github:nixos/nixpkgs/nixos-25.11";
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
    # Idk what happened, this repo just disappeared
    # zapret-discord-youtube = {
    #   url = "github:kartavkun/zapret-discord-youtube";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    happ-nix = {
      url = "github:DaHL-gh/happ-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # omnisearch = {
    #   # url = "git+https://git.bwaaa.monster/omnisearch";
    #   url = ./omnisearch;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    xlibre-overlay = {
      url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, nur, unstable, ultrastable, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "inf"; #< Here you can change username
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

    pkgs = nixpkgs.legacyPackages.${system};
    # https://discourse.nixos.org/t/how-to-make-one-flake-nix-for-multiple-hosts/62056
    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
        unstable = import unstable {
          inherit system;
        };
        ultrastable = import ultrastable {
          inherit system;
        };
        nur = import nur {};
        inherit inputs system;
        inherit username;
        inherit hostname;
        inherit system_info;
      };
      modules = with inputs; [
        ./configuration.nix
        nur.modules.nixos.default
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix

        musnix.nixosModules.musnix
        # zapret-discord-youtube.nixosModules.withTestTools
        happ-nix.nixosModules.default
        {
          programs.happ = {
            enable = true;
            tunMode.enable = true;
          };
          # systemd.services.happ.serviceConfig.Capabilities = [ "CAP_NET_ADMIN" ];
          systemd.services.happ.serviceConfig = {
            Capabilities = [ "CAP_NET_ADMIN" ];
            AmbientCapabilities = [ "CAP_NET_ADMIN" ];
            CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
          };
        }
        xlibre-overlay.nixosModules.overlay-xlibre-xserver
        xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
        # omnisearch.nixosModules.default
        # {
        #   services.omnisearch.enable = true;
        # }
        (
          {pkgs, ...}:
          {
            # Using architecure specific kernel don't really seem to change anything that much
            # lto also doesn't really change performance according to benchmarks (but compiles
            # 50% slower)
            # Amoung all default kernels 'zen' seems like the best one, so if you don't want to
            # wait chachy kernel compilation, you can use zen kernel, but you will sacrifice a
            # little bit of performance.
            boot.kernelPackages = pkgs.linuxPackages_zen;

            # nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ]; # Uncomment this if you want to use cashyos kernel
            # boot.kernelPackages = let
            #   kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
            #     pname = "linux-cachyos-latest-rt-bore-x86_64-v3";
            #     cpusched = "rt-bore";
            #     processorOpt = "x86_64-v3";
            #     rt = true;
            #   };
            # in
            # pkgs.linuxKernel.packagesFor kernel;
            # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
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
        unstable = import unstable {
          inherit system;
        };
        ultrastable = import ultrastable {
          inherit system;
        };
        nur = import nur {};
        inherit username pkgs;
        inherit system_info;
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
