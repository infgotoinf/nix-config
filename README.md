# -inf's nix config

## Installation

<!-- ### Non NixOS distro -->

<!-- ``` shell -->
<!-- NIXPKGS_ALLOW_UNFREE=1 home-manager switch --extra-experimental-features nix-command --extra-experimental-features flakes --impure --flake .#HOSTNAME -->
<!-- ``` -->

### NixOS

<!-- TODO: create a script for simpler installation and change installation steps -->
> [!WARNING]
> Installation guide has too many steps. Gonna fix this later.

1. Install [Minimal NixOS ISO](https://nixos.org/download/#nixos-iso)

1. Clone and enter the repo
   ```sh
   git clone https://github.com/infgotoinf/nix-config.git --depth 1 && cd nix-config
   ```

1. Edit disco config

> [!NOTE]
> You can learn more about disko on the [official disko repo](https://github.com/nix-community/disko)

```sh
EDITOR etc/disko/btrfs-swap.nix
```

4. Run it

> [!WARNING]
> This action will destroy all data on sellected disk! Be sure you followed previous step.

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount etc/disco/btrfs-swap.nix
```
    
5. Install NixOS

   ```sh
   sudo nixos-generate-config --root /mnt && sudo nixos-install
   ```

1. Edit config (add user, experimental features (nix.settings.experimental-features = [ "nix-command" "flakes" ])) passwd user

   ```sh
   sudo nixos-enter
   nano /etc/nixos/configuration.nix
   nix-channel --add https://nixos.org/channels/nixpkgs-unstable && nix-channel --update
   nixos-rebuild boot
   ctrl+D sudo nixos-enter
   passwd USERNAME
   ```

1. Login into user account, git clone this repo, add host configs and rebuild

   ```sh
   cd /home/USER
   nix-shell -p git
   git clone https://github.com/infgotoinf/nix-config.git
   cd nix-config
   cp /etc/nixos/hardware-configuration.nix modules/hosts/HOST-NAME.nix
   touch home-modules/hosts/HOST-NAME.nix
   nixos-rebuild boot --flake .#HOSTNAME --impure
   reboot
   NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure --flake .#HOSTNAME
   ```

You're done!
