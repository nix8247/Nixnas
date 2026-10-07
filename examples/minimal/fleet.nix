# Fleet layer (example): shared across this deployer's machines.
# This is where end-user configuration starts — user profiles, roles
# hosts opt into, fleet-wide firewall openings.
{ ... }:

{
  nixnas.admins = [
    { name = "tim"; sshKeys = [ "ssh-ed25519 AAAAEXAMPLE tim@laptop" ]; }
  ];

  # Rolling latest channel: this box rebuilds from the fleet repo's main
  # branch weekly. For a locked snapshot, point at a tag instead, e.g.
  # "github:you/nixnas-fleet/v1.2.3#nas01".
  nixnas.updates.flake = "github:you/nixnas-fleet#nas01";

  # Fleet-wide firewall: SMB for the LAN, for example. Note this list
  # *replaces* the default — keep 22 (SSH) unless you mean to drop it.
  nixnas.firewall.allowedTCPPorts = [ 22 445 ];
}
