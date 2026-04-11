{ hostname, ... }:

{
  imports = [
    ./${hostname}.nix

    ./drivers.nix
    ./boot-kernel.nix
    ./network.nix
    ./zram-swap.nix
    ./performance.nix
  ];
}
