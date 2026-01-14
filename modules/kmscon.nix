{ pkgs, lib, config, ... }: {

  options = {
    kmscon.enable = lib.mkEnableOption ''
      Enables kmscon virtual console instead of gettys.
      Kmscon supports unicode and uses gpu for fast
      console rendering. Without this option tty will not
      render icon characrers.
    '';
  };
 
  config = lib.mkIf config.kmscon.enable {
    services.kmscon = {
      enable = true;
      # hwRender = true; # Causes bad character antialising
      extraConfig = ''
      '';
    };
  };
}
