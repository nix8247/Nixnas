# Fleet layer (example): shared across this deployer's machines.
# This is where end-user configuration starts — user profiles, roles
# hosts opt into, fleet-wide firewall openings.
_: {
  nixnas = {
    admins = [
      {
        name = "tim";
        sshKeys = ["ssh-ed25519 AAAAEXAMPLE tim@laptop"];
      }
    ];

    # Rolling latest channel: this box rebuilds from the fleet repo's main
    # branch weekly. For a locked snapshot, point at a tag instead, e.g.
    # "github:you/nixnas-fleet/v1.2.3#nas01".
    updates.flake = "github:you/nixnas-fleet#nas01";
  };

  # Fleet-wide firewall: SMB for the LAN, for example. This *adds to* the
  # ports core modules open themselves (22 comes from ssh.nix) — NixOS
  # merges the lists, so there's nothing to keep in sync.
  networking.firewall.allowedTCPPorts = [ 445 ];
}
