{
  imports = [
    # ./shell-zsh.nix
    ./shell-fish.nix
    ./starship.nix

    ./cli
    ./tui
    ./gui
    ./programming
    ./desktop-environment

    ./tmux.nix
    ./terminal-emulator-wezterm.nix
    ./terminal-emulator-alacritty.nix
    ./application-launcher-rofi.nix
  ];
}
