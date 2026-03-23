# Template from https://github.com/nix-community/disko/example/btrfs-only-root-subvolume.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
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
              # (but if you're too griddy you actually can. In my personal experience I didn't see boot parition
              # taking more than 100M, but know that you're doing)
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
                type = "btrfs";
                extraArgs = [ "-f" "-O block-group-tree" ];
                mountpoint = "/";
                # https://btrfs.readthedocs.io/en/latest/ch-mount-options.html
                mountOptions = [
                  "compress=zstd"
                  "noatime"
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
