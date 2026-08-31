{ pkgs, ... }:
{
  boot = {
    kernelParams = [
      # https://www.techpowerup.com/338254/intel-gpus-gain-20-performance-by-disabling-security-mitigations
      "NEO_DISABLE_MITIGATIONS=1"
    ];
    loader = {
      timeout = 0; # Mash space on boot to select different generation
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Using architecure specific kernel don't really seem to change anything that much
  # lto also doesn't really change performance according to benchmarks (but compiles
  # 50% slower)
  # Amoung all default kernels 'zen' seems like the best one, so if you don't want to
  # wait chachy kernel compilation, you can use zen kernel, but you will sacrifice a
  # little bit of performance.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # NOTE: This was copy-pasted from ../../flake.nix, so you'll need to add cachyos
  # flake to modules and edit this thing.
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
