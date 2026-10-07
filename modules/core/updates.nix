# Pull-based updates: each machine rebuilds itself from git on a schedule.
# Nothing pushes to the machines — updating needs only outbound network
# access, the nixbook set-and-forget model.
#
# This is the "latest" (rolling) channel: point `nixnas.updates.flake` at
# a branch and the box stays current. For a locked snapshot, point it at
# a tag instead — same mechanism, pinned software versions.
#
# Safety nets: every rebuild keeps the previous NixOS generations in the
# boot menu, so a bad update is one reboot away from the last good one.
{
  config,
  lib,
  ...
}: let
  cfg = config.nixnas.updates;
in {
  options.nixnas.updates = {
    flake = lib.mkOption {
      type = lib.types.str;
      description = ''
        Flake reference this machine pulls and rebuilds from, e.g.
        "github:you/nixnas-fleet#nas01". Use a branch for the rolling
        latest channel, or a tag (github:you/nixnas-fleet/v1.2.3#nas01)
        for a locked snapshot.
      '';
      example = "github:you/nixnas-fleet#nas01";
    };
    schedule = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = "How often to pull and rebuild (systemd calendar expression).";
    };
  };

  system.autoUpgrade = {
    enable = true;
    inherit (cfg) flake;
    dates = cfg.schedule;
    flags = ["--refresh"];
    # Reboots stay manual: the new generation is built and staged, and
    # you reboot when ready.
    allowReboot = lib.mkDefault false;
  };
}
