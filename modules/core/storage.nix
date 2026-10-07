# Storage: the core declares which filesystems a Nixnas box understands
# and ships the tools. Actual disks, pools, and layouts are host-level
# decisions — see the storage plan in the Nixnas-plan repo.
#
# Tiers (project opinion, mechanism only):
#   Tier 1 — ZFS mirrors for irreplaceable data.
#   Tier 2 — per-disk btrfs or bcachefs, pooled with mergerfs,
#            protected by SnapRAID (bcachefs does not replace btrfs).
{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.nixnas.enable {
    # Declaring support here only means the drivers land in the initrd
    # when a host actually uses the filesystem.
    boot.supportedFilesystems = ["btrfs" "zfs" "bcachefs"];

    environment.systemPackages = with pkgs; [
      btrfs-progs
      bcachefs-tools
      zfs
      mergerfs
      snapraid
    ];

    services.fstrim.enable = lib.mkDefault true;
  };
}
