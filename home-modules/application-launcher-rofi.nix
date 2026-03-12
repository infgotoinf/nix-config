{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      max-history = 10;
    };
    modes = [
      "drun"
      "emoji"
      # "nerdy"
    ];
    plugins = with pkgs; [
      rofi-emoji
      # rofi-nerdy
    ];
  };
}
