# The Nixnas core module — the entry point a host config imports.
#
# Everything under `nixnas.*` is project-owned and hardware-agnostic:
# no hostnames, no disks, no drivers here. Machine specifics live in
# the host layer of the deployer's own flake.
#
# Importing this module enables the core. There is no `nixnas.enable`
# flag — every feature module below is self-contained and applies when
# imported, dendritic-style.
#
# Feature modules are auto-imported: every .nix file next to this one
# (except this file) is one feature, named by its path. Adding a file
# is enough — there is no imports list to maintain, and files can be
# renamed or split freely.
{lib, ...}: {
  imports = let
    files = builtins.attrNames (builtins.readDir ./.);
    isFeature = f: f != "nixnas.nix" && lib.hasSuffix ".nix" f;
  in
    map (f: ./. + "/${f}") (builtins.filter isFeature files);
}
