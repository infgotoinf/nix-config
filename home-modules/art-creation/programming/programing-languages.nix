{ pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    gcc
    # Got wierd
    # "version `GLIBC_2.43' not found" errors recently, don't recomend to
    # comment this line
    unstable.glibc
    gnumake
    unstable.bear
    cmake
    # ninja
    # lua
    ruby
    nodejs
    # If you install them in a `shell.nix` datetime.today().dispaly() will be
    # returning 1980-01-01, if you install them like this - you won't get any
    # problems
    unstable.typst
    touying

    # Docs
    # cppman
  ];
}
