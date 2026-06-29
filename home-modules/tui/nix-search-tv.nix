{ pkgs, unstable, ... }: let

# Tony is sigma btw https://www.tonybtw.com/community/nix-search-tv/
tv = pkgs.writeShellApplication {
    name = "tv";
    runtimeInputs = with pkgs; [
      fzf
      unstable.nix-search-tv
    ];
    text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
  };

in {
  home.packages = [
    tv
  ];
}
