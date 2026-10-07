# The Nixnas core module — the entry point a host config imports.
#
# Everything under `nixnas.*` is project-owned and hardware-agnostic:
# no hostnames, no disks, no drivers here. Machine specifics live in
# the host layer of the deployer's own flake.
#
# Importing this module enables the core. There is no `nixnas.enable`
# flag — every feature module below is self-contained and applies when
# imported, dendritic-style.
_: {
  imports = [
    ./core/firewall.nix
    ./core/ssh.nix
    ./core/users.nix
    ./core/podman.nix
    ./core/updates.nix
    ./core/storage.nix
    ./core/nix-settings.nix
  ];
}
