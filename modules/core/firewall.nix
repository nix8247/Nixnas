# Firewall baseline: on by default. That's the whole module — ports are
# opened where the service lives (ssh.nix opens 22), and NixOS merges
# `networking.firewall.*` lists across modules, so fleet/host just add
# their own with plain `networking.firewall.allowedTCPPorts`.
{ lib, ... }: {
  networking.firewall.enable = lib.mkDefault true;
}
