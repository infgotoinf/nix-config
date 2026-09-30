# Template from https://github.com/nix-community/disko/blob/master/example/btrfs-only-root-subvolume.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdX"; # Consider changing device to desired one. 'lsblk' to list all devices
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              # Since NixOS stores all installed kernels' versions in boot, I don't recommend going below 0.5GiB
              # https://discourse.nixos.org/t/boot-partition-is-too-small-and-becoming-full/32194
              end = "1GiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "RAM-SIZE"; # For example "8G" or "16G"
              content = {
                type = "swap";
                resumeDevice = true;
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
                  "noatime"
                  "nodatacow"
                  "nodatasum"
                ];
              };
            };
          };
        };
      };
    };
  };
}
