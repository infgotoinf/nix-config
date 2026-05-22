{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    libGL

    # X11 dependencies
    libX11
    libX11.dev
    libXcursor
    libXi
    libXinerama
    libXrandr
  ];
}
