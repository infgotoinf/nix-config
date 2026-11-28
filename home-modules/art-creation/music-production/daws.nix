{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lmms-full
    qt5.qtwayland # For lmms

    furnace
    audacity # Not really a DAW, but yes
    # reaper
    # ardour
  ];
}
