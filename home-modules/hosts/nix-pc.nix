{
  imports = [
    ./nix-laptop.nix
  ];

  has_nvidia_gpu = true;

  services.wayvnc = {
    enable = true;
    settings = {
      address = "0.0.0.0";
      port = 5900;
    };
  };
}
