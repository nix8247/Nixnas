# Host layer (example): this particular box. The only place hardware,
# disks, and machine identity may appear.
_: {
  networking.hostName = "nas01";

  # Required by core's ZFS support (pool imports are keyed to it).
  # Must be unique per machine — set it for real on every host.
  networking.hostId = "deadbeef";

  # On real hardware, ./hardware-configuration.nix gets imported here,
  # and the disk layout (see the disko reference in Nixnas-installer)
  # is declared here too. bcachefs root, per the installer default:
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "bcachefs";
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.11";
}
