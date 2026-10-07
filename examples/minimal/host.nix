# Host layer (example): this particular box. The only place hardware,
# disks, and machine identity may appear.
{ ... }:

{
  nixnas.enable = true;
  networking.hostName = "nas01";

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
