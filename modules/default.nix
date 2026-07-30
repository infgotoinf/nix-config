{
  imports = [
    ./hardware
    ./input

    ./tty-console.nix
    ./ssh.nix

    ./display-manager-ly.nix

    ./xserver.nix
    ./wayland.nix
    ./virtual-machine-gnome-boxes.nix
    ./docker.nix

    ./nh.nix
  ];
}
