{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.video-editing.enable {
    home.packages = with pkgs; [
      frei0r
    ];
  };
}
