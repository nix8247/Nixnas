# Nixnas — an opinionated NixOS core for home servers.
#
# This flake is the "package" a host configuration imports. A deployer's
# own flake does:
#
#   inputs.nixnas.url = "github:nix8247/Nixnas";
#   ...
#   modules = [ nixnas.nixosModules.default ./hardware-configuration.nix ];
#
# What lives here is the core layer only: project-owned, shared by every
# machine, and hardware-agnostic. Fleet (shared deployer config) and host
# (per-machine specifics) live in the deployer's repo — see
# examples/minimal for the three layers working together.
#
# Design rationale: https://github.com/nix8247/Nixnas-plan
{
  description = "Nixnas — an opinionated NixOS core for home servers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules.default = import ./modules/nixnas.nix;
    nixosModules.nixnas = self.nixosModules.default;
  };
}
