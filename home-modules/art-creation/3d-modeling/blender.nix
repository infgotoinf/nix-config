{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.modeling.enable {
    home.packages = with pkgs; [
      blender
    ];
  };
}
