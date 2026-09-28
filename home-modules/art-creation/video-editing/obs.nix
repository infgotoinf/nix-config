{ lib, config, ... }:
{
  config = lib.mkIf config.video-editing.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
