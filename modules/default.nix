{
  imports = [
    ./hardware
    ./input

    ./tty-console.nix
    ./ssh.nix

    ./display-manager-ly.nix

    ./xserver.nix
    ./virtual-machine.nix
    ./docker.nix

    ./nh.nix
  ];
}
