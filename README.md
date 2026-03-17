# -inf's nix config

> [!WARNING]
> Very-very work in progress, don't recomend to use.

## Installation

TODO: Make a script

1. Choose a disco config you'd like to use (they're located in 'etc/disko' folder). And edit 'device' to the disk you'd like to install NixOS on.

2. In the following command replace 'path/to/disko.nix' with actual path to disko config you'd like to use and then run it.

```console
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount path/to/disko.nix
```
> [!NOTE]
> You can learn more about disco on the [official disko repo](https://github.com/nix-community/disko)

3. Install NixOS

```console
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
