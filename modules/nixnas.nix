# The Nixnas core module — the entry point a host config imports.
#
# Everything under `nixnas.*` is project-owned and hardware-agnostic:
# no hostnames, no disks, no drivers here. Machine specifics live in
# the host layer of the deployer's own flake.
{lib, ...}: {
  imports = [
    ./core/firewall.nix
    ./core/ssh.nix
    ./core/users.nix
    ./core/podman.nix
    ./core/updates.nix
    ./core/storage.nix
    ./core/nix-settings.nix
  ];

  options.nixnas.enable = lib.mkEnableOption "the Nixnas core platform";
}
