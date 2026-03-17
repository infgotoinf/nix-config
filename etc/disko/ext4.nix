# Template from https://github.com/nix-community/disko/example/btrfs-only-root-subvolume.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # I don't use ext4 so I'm not really sure about this config,
        # but you can check my btrfs.nix config though, I'm 100% sure about it.
        device = "/dev/sdX"; # Consider changing device to desired one. 'fdisk -l' to list all devices
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              # Since NixOS stores all installed kernels' versions in boot, I don't recommend going below 512M
              # https://discourse.nixos.org/t/boot-partition-is-too-small-and-becoming-full/32194
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                extraArgs = [ "-f" ];
                mountpoint = "/";
                # https://btrfs.readthedocs.io/en/latest/ch-mount-options.html
                mountOptions = [
                  "defaults"
                  "noatime"
                  
                  "errors=remount-ro"
                  "commit=60"

                  # "journal_async_commit"
                ];
              };
            };
            # Notice what there is no swap, cause insead of swap configuration uses ZRAM
          };
        };
      };
    };
  };
}
