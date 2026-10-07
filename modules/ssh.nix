# SSH: the way in. Key-only, no root login, no password auth.
# Opens its own firewall port — the firewall module knows nothing about SSH.
# Admins and their keys are declared via `nixnas.admins` (users.nix).
_: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # NixOS merges allowedTCPPorts across modules, so this simply adds 22
  # to whatever fleet/host open — no coordination needed.
  networking.firewall.allowedTCPPorts = [22];
}
