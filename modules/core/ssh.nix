# SSH: the way in. Key-only, no root login, no password auth.
# Admins and their keys are declared via `nixnas.admins` (users.nix).
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.nixnas.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
