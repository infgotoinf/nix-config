{ pkgs, lib, config, username, ... }:

{
  options = {
    gnome-boxes.enable = lib.mkEnableOption ''
      Enables gnome boxes for VM management
    '';
  };

  config = lib.mkIf config.gnome-boxes.enable {
    # Set up virtualisation
    virtualisation.libvirtd = {
      enable = true;

      # Enable TPM emulation (for Windows 11)
      qemu = {
        swtpm.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    # Enable USB redirection
    virtualisation.spiceUSBRedirection.enable = true;

    # Allow VM management
    users.groups.libvirtd.members = [ username ];
    users.groups.kvm.members = [ username ];

    # Enable VM networking and file sharing
    environment.systemPackages = with pkgs; [
      gnome-boxes # VM management
      dnsmasq # VM networking
      phodav # (optional) Share files with guest VMs
    ];

    hardware.facter.detected.virtualisation.qemu.enable = true;
  };
}
