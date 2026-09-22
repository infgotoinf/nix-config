{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    cmake
    # lua
    ruby
    nodejs
    # If you install them in a `shell.nix` datetime.today().dispaly() will be
    # returning 1980-01-01, if you install them like this - you won't get any
    # problems
    typst
    touying

    # Docs
    cppman
  ];
}
