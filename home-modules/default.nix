{
  imports = [
    ./shell-fish.nix
    ./starship.nix

    ./cli
    ./tui
    ./gui
    ./programming
    ./desktop-environment

    ./tmux.nix
    ./terminal-emulator-wezterm.nix
    ./application-launcher-rofi.nix
  ];
}
