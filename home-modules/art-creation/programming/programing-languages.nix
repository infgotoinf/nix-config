{ pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    bear
    cmake
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
