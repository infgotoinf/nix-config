{ lib, ... }:
{
  options = {
    drawing.enable = lib.mkEnableOption "drawing tools";
    music-production.enable = lib.mkEnableOption "music production tools";
    modeling.enable = lib.mkEnableOption "3D modeling tools";
    video-editing.enable = lib.mkEnableOption "video editing tools";
  };

  imports =
  [
    ./programming
    ./drawing
    ./music-production
    ./3d-modeling
    ./video-editing
  ];
}
