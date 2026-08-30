{ pkgs, ... }:
let
  eo_bundle = pkgs.stdenvNoCC.mkDerivation {
    pname = "eo-bundle";
    version = "v2";

    src = pkgs.fetchurl {
      url = "https://github.com/EyeOdin/eo_bundle/raw/refs/heads/main/EO_Bundle_v2.bundle";
      hash = "sha256-zV1NymjEPxQUUyqup0GCuJ1Ob221GXalSk/cbCJF49o=";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp $src $out
    '';
  };
in {
  home.file.".local/share/krita/EO_Bundle_v2.bundle" = {
    source = eo_bundle.src;
    force = true;
  };
}
