{ pkgs, lib, config, ... }: {
  services.displayManager = {
    enable = true;
    ly = {
      enable = true;
      x11Support = true;
      settings = {
        
      };
    };
    environment = {
      
    };
  };
}
