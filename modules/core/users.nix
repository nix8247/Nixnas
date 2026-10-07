# Admin users: who can SSH in (wheel group, keys only).
# SSH keys are public by design, so declaring them here is safe —
# no secrets live in core, ever.
{ config, lib, ... }:
let cfg = config.nixnas; in
{
  options.nixnas.admins = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Login name.";
        };
        sshKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys for this admin.";
        };
      };
    });
    default = [ ];
    description = "Admin users created on every Nixnas machine.";
    example = [
      { name = "tim"; sshKeys = [ "ssh-ed25519 AAAA... tim@laptop" ]; }
    ];
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (cfg.admins == [ ])
      "nixnas: no admins declared — nobody will be able to SSH in. Set nixnas.admins.";

    users.users = lib.listToAttrs (map
      (a: {
        name = a.name;
        value = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = a.sshKeys;
        };
      })
      cfg.admins);
  };
}
