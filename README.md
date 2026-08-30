# -inf's nix config

<!-- TODO: create a script for simpler installation and change installation steps -->
> [!WARNING]
> Installation guide has too many steps. Gonna fix this later.

## Installation

1. Edit disco config

> [!NOTE]
> You can learn more about disco on the [official disko repo](https://github.com/nix-community/disko)

```shell
EDITOR etc/disko/btrfs.nix
```
2. Run it

> [!WARNING]
> This action will destroy all data on sellected disk! Be sure you followed previous step.

```shell
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount etc/disco/btrfs.nix
```
3. Install NixOS

```shell
sudo nixos-generate-config --root /mnt && sudo nixos-install
```

4. Edit config (add user, experimental features (nix.settings.experimental-features = [ "nix-command" "flakes" ])) passwd user
```shell
sudo nixos-enter
nano /etc/nixos/configuration.nix
nix-channel --add https://nixos.org/channels/nixpkgs-unstable && nix-channel --update
nixos-rebuild boot
ctrl+D sudo nixos-enter
passwd USERNAME
```

5. Login into user account, git clone this repo, replace modules/hardware/hardware-configuration.nix with /etc/nixos/hardware-configuration.nix and rebuild
```shell
cd /home/USER
nix-shell -p git
git clone https://github.com/infgotoinf/nix-config.git
cd nix-config
mv moudles/hardware/hardware-configuration.nix modules/hardware/hardware-configuration.nix.old
cp /etc/nixos/hardware-configuration.nix moduels/hardware/
nixos-rebuild boot --flake .
reboot
nh os home switch
```

You're done!
