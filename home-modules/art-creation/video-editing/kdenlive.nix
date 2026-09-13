{ pkgs, lib, ... }:
let
  # This all is to make SAM2 plugin work
  python_for_kdenlive = pkgs.python3.withPackages (ps: with ps; [
    torch
    opencv-python
    sam2
  ]);
in
{
  home.packages = with pkgs; [
    (pkgs.kdePackages.kdenlive.overrideAttrs (oldAttrs: {
      # We need this to make SAM2 not crash
      postFixup = ''
        sed -i "s|^Exec=|Exec=${pkgs.steam-run-free}/bin/steam-run |" $out/share/applications/org.kde.kdenlive.desktop
      '';
    }))
    python_for_kdenlive
  ];

  home.file.".local/share/kdenlive/venv-sam/bin/python".source = "${python_for_kdenlive}/bin/python";

  home.activation.kdenlive_setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.local/share/kdenlive/shortcuts
    chmod -R u+rw ~/.local/share/kdenlive/shortcuts
    cp ${./.}/bread_kdenlive.shortcuts ~/.local/share/kdenlive/shortcuts
  '';
}
