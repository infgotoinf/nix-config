{
  imports = [
    ./shell-zsh.nix

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
