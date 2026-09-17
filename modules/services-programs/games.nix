{ pkgs, ...}:
{
  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
    };
  };
}
