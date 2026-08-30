{ pkgs, lib, ... }:
{
  # home.file = {
  #   ".config/gmic/gmic_qt_faves.json" = {
  #     source = "${./krita-settings}/gmic_qt_faves.json";
  #     force = true;
  #   };
  #   ".config/kritashortcutsrc" = {
  #     source = "${./krita-settings}/infs_krita_shortcurs2.shortcuts";
  #     force = true;
  #   };
  #   ".local/share/krita/palettes/krita_spectrum_pallette.kpl" = {
  #     source = "${./krita-settings}/krita_spectrum_palette.kpl";
  #     force = true;
  #   };
  #   ".local/share/krita/workspaces" = {
  #     source = "${./krita-settings}/workspaces";
  #     force = true;
  #   };
  # };
  home.activation.krita_plugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/gmic
    chmod -R u+rw ~/.config/gmic
    cp ${./krita-settings}/gmic_qt_faves.json ~/.config/gmic/

    chmod -R u+rw ~/.config/kritashortcutsrc
    cp ${./krita-settings}/infs_krita_shortcuts2.shortcuts ~/.config/kritashortcutsrc

    mkdir -p ~/.local/share/krita/palettes
    chmod -R u+rw ~/.local/share/krita/palettes
    cp ${./krita-settings}/krita_spectrum_palette.kpl ~/.local/share/krita/palettes/

    mkdir -p ~/.local/share/krita/workspaces
    chmod -R u+rw ~/.local/share/krita/workspaces
    cp ${./krita-settings}/workspaces/* ~/.local/share/krita/workspaces
  '';
  home.packages = with pkgs; [
    krita
    krita-plugin-gmic
  ];
}
