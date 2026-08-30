{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      set -U fish_color_valid_path blue

      set -U sponge_delay 5
    '';
    binds = {

    };
    functions = {

    };
    shellAbbrs = {
      # hs = "NIXPKGS_ALLOW_UNFREE=1 nh home switch --impure --show-activation-logs";
      hs = "nh home switch --impure --show-activation-logs";
      ns = "nix-shell --run fish";
      oss = "sudo nh os switch --impure -RH";
      ost = "sudo nh os test --impure -RH";
      osb = "sudo nh os boot --impure -RH";
      call = "nh clean all --optimise";
      # unfree = "NIXPKGS_ALLOW_UNFREE=1";
    };
    shellAliases = {
      s = "ls";
      cd = "z";
      ls = "eza ";
      # rg = "batgrep --no-separator --no-snip ";
      rg = "batgrep --no-highlight --no-snip ";
      man = "batman ";
      cat = "bat --paging=never --style=plain ";
      diff = "batdiff ";
      gdb = "gdb-dashboard ";
      ds = "devbox shell";

      btrfs-balance = "sudo btrfs balance start -dusage=10 -musage=10 /";
      dd-measure-disk-write-speed = "dd if=/dev/zero of=$HOME/lol.img bs=1G count=1 oflag=dsync; rm -rf $HOME/lol.img";
      run-system-benchmark = "NIXPKGS_ALLOW_UNFREE=1 nix run github:dbeley/nixos-benchmark -- --benchmarks openssl-speed,7zip-benchmark,stress-ng,sysbench-cpu,sysbench-memory,furmark-gl,stressapptest-memory,fio-seq,iozone,bonnie++,ioping,furmark-vk,clpeak,hashcat-gpu,lz4-benchmark,zstd-compress,cryptsetup-benchmark,sqlite-mixed,sqlite-speedtest,ffmpeg-transcode,netperf,wrk-http";
    };
    plugins = with pkgs.fishPlugins; [
      { # Automaitcally clears history from typos
        # https://github.com/meaningful-ooo/sponge
        name = "sponge";
        inherit (sponge) src;
      }
      { # Quality of life
        # https://github.com/nickeb96/puffer-fish
        name = "puffer";
        inherit (puffer) src;
      }
    ];
  };
}
