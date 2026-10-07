# Passwordless sudo for admins.
#
# Off by default: a sudo password is a second barrier if an admin's SSH
# key is ever compromised. Turn it on for convenience on boxes you only
# ever reach over SSH anyway (every `nixos-rebuild` needs sudo).
#
# Note on the no-wrapper-options convention: this looks like a thin
# wrapper around `security.sudo.wheelNeedsPassword`, but it earns its
# place — it names a project-level policy ("admins get passwordless
# sudo") with a secure default, in vocabulary a non-developer deployer
# can find. Finer control (per-user, per-command) stays a fleet/host
# level `security.sudo` setting.
{
  config,
  lib,
  ...
}: {
  options.nixnas.sudo.passwordless = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = "Let members of wheel (all nixnas admins) sudo without a password.";
  };

  config = lib.mkIf config.nixnas.sudo.passwordless {
    security.sudo.wheelNeedsPassword = false;
  };
}
