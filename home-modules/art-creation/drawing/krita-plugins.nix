{ pkgs, ... }:
let
  # Mainly used to use same shortcut for different things like different types of selection
  shortcut-composer = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "shortcut-composer";
    version = "1.7.1";
    src = pkgs.fetchzip {
      url = "https://github.com/wojtryb/Shortcut-Composer/releases/download/v${version}/Shortcut-Composer-${version}.zip";
      hash = "sha256-G/Aos9tE8ssg1sUdZEjWvdeV2joS63Sf25RdbizVKjE=";
    };

    # dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r "$src/*" "$out/"
    '';
  };
in {
  home = {
    file.".local/share/krita/pykrita/shortcut_composer" = {
      source = "${shortcut-composer.src}/shortcut_composer";
      force = true;
    };
    file.".local/share/krita/pykrita/shortcut_composer.desktop" = {
      source = "${shortcut-composer.src}/shortcut_composer.desktop";
      force = true;
    };
  };
}
