{ hostname, ... }:

{
  imports = [
    ./${hostname}.nix

    ./drivers.nix
    ./boot-kernel.nix
    ./network.nix
    ./memory.nix
    ./performance.nix
  ];
}
